//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//  Wrapper for Lab 2: spimemory
// 
//  Rationale: 
//     The ZYBO board has 4 buttons, 4 switches, and 4 LEDs. We want to be able to verify the miso pin
//     so we need to display the current miso value and have another indicator to indicate if it is tristated to //     differentiate between '0' and 'z'. 
//  Usage:
//     sw0 - Serial In Input into input conditioner -> shift register
//     sw1 - Clk Edge
//     sw2 - Chip Select
//     led0 - Miso
//     led3 - Tristated?
//     Note: Buttons, switches, and LEDs have the least-significant (0) position
//     on the right.      
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Basic building block modules
//--------------------------------------------------------------------------------


module dff #(parameter W = 1)
(
  input trigger,
  input enable,
  input [W-1:0] d,
  output reg [W-1:0] q
);
  always @ (posedge trigger) begin
    if(enable) begin
      q <=d;
    end
  end

endmodule

module dlatch 
(
  input [7:0] data ,
  input clk,
  input addr_we,
  output reg [6:0] addr
);

always @(posedge clk) begin
  if(addr_we) begin
    addr = data[7:1];
  end 
end

endmodule


module tristatebuffer(out,in,en);
    input in;
    input en;
    output out;
    
    assign out = en ? in : 1'bz;
    
endmodule

//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

module inputconditioner
(clk,noisysignal,conditioned,positiveedge,negativeedge);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles

    input clk;
    input noisysignal;
    output reg conditioned;
    output reg positiveedge;
    output reg negativeedge;
    
    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;
    reg conditioned1 = 0;
    
    always @(posedge clk ) begin
		if(conditioned1 == 0 && conditioned == 1) begin
			negativeedge = 1;
		end else if (conditioned1 == 1 && conditioned == 0) begin
			positiveedge = 1;
        end else if (positiveedge == 1 || negativeedge == 1) begin
            positiveedge = 0;
            negativeedge = 0;
        end
        if(conditioned1 == synchronizer1)
            counter <= 0;
        else begin
            if( counter == waittime) begin
                counter <= 0;
                conditioned1 <= synchronizer1;
            end
            else 
                counter <= counter+1;
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
		conditioned <= conditioned1;
    end
endmodule

//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output reg [width-1:0]  parallelDataOut,    // Shift reg data contents
output reg             serialDataOut       // Positive edge synchronized
);

    reg [width-1:0]      shiftregistermem;

    always @(posedge clk) begin

        if(parallelLoad==1) begin
        // load the register with parallelDataIn
        	shiftregistermem <= parallelDataIn;
        end

        else if(parallelLoad==0) begin
        	if(peripheralClkEdge==1) begin
        	//grab the MSB as SDO and then shift everything over 1 place
        	    serialDataOut <= shiftregistermem[width-1];
        		shiftregistermem<={shiftregistermem[width-2:0],serialDataIn};
        	end	
        end
        //parallelDataOut is just the current state of the register
        parallelDataOut <= shiftregistermem;

    end
endmodule


//------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//------------------------------------------------------------------------

module datamemory
#(
    parameter addresswidth  = 7,
    parameter depth         = 2**addresswidth,
    parameter width         = 8
)
(
    input                       clk,
    output reg [width-1:0]      dataOut,
    input [addresswidth-1:0]    address,
    input                       writeEnable,
    input [width-1:0]           dataIn
);


    reg [width-1:0] memory [depth-1:0];

    always @(posedge clk) begin
        if(writeEnable)
            memory[address] <= dataIn;
        dataOut <= memory[address];
    end

endmodule


//------------------------------------------------------------------------
// Finite State Machine
//
//                MISO_BUFF            DM_WE            ADDR_WE          SR_WE
//CS              0                    0                0                0
//~CS             0                    0                1                1
//shiftRegOutP[0] 1                    0                0                1
//~shiftRegOutP[0]0                    1                0                0
//
//------------------------------------------------------------------------

//                MISO_BUFF            DM_WE            ADDR_WE          SR_WE
//CS              0                    0                0                0
//~CS             0                    0                1                1
//shiftRegOutP[0] 1                    0                0                1
//~shiftRegOutP[0]0                    1                0                0
module fsm(MISO_BUFF,DM_WE,ADDR_WE,SR_WE,POS_EDGE,CS,shiftRegOutP0,clk);
   input POS_EDGE;
   input CS;
   input shiftRegOutP0;
   input clk;
   output MISO_BUFF;
   output DM_WE;
   output ADDR_WE;
   output SR_WE;

   reg [1:0] state;
   reg MISO_BUFF,DM_WE,ADDR_WE,SR_WE;
   wire [1:0] next_state;
   parameter counter_num_bits = 4;
   reg[counter_num_bits-1:0] counter = 0;

   assign next_state = fsm_function(state,POS_EDGE,CS,shiftRegOutP0);   

   function [1:0] fsm_function;
      input [1:0] state;
      input POS_EDGE;
      input CS;
      input shiftRegOutP0;
      case(state)
        2'b00:if(!CS) begin
                 fsm_function = 2'b01;
              end
        2'b01:if(shiftRegOutP0) begin
                 fsm_function = 2'b10;
              end else if (!shiftRegOutP0) begin
                 fsm_function = 2'b11;
              end
        2'b10:if(CS) begin
                 fsm_function = 2'b00;
              end
        2'b11:if(CS) begin
                 fsm_function = 2'b00;
              end
        default:fsm_function = 2'b00;
      endcase
   endfunction

   always @ (posedge clk) begin
      state <= next_state;
      if (next_state == 2'b00) begin
         MISO_BUFF <= 0;
         DM_WE <= 0;
         SR_WE <= 0;
		 ADDR_WE <= 0;
      end else if (next_state == 2'b01) begin
         if(POS_EDGE) begin
           counter <= 1;
         end
         SR_WE <= 1;
      end else if (next_state == 2'b10) begin
         MISO_BUFF <= 1;
         ADDR_WE <= 0;
      end else if (next_state == 2'b11) begin
         DM_WE <= 1;
         ADDR_WE <= 0;
         SR_WE <= 0;
      end
      if (counter==7)begin
        ADDR_WE<=1;
		counter <= counter + 1;
      end
      else if (counter==8)begin
        ADDR_WE <=0;
        counter<=0;
      end
      else if (counter>0)begin
        counter<=counter+1;
      end
   end
endmodule

//--------------------------------------------------------------------------------
// Main Lab 2 wrapper module
//   Interfaces with switches, buttons, and LEDs on ZYBO board. Allows for two
//   operations: read and write. 8 bits are entered (first 7 are address and the last is a R/W flag)
//   Read:
//   Write: 
//   sw[0] = mosi pin
//   sw[1] = clk edge
//   sw[2] = chip select
//   led0  = miso
//   led3  = tristated
//--------------------------------------------------------------------------------

module spiMemory(clk,sw,led);
    input clk;
    input [2:0] sw;
    output reg [3:0] led;
 
    wire[7:0] parallelData;    // ParallelData Out
    wire[6:0] address; 		  // address
    wire[3:0] res0, res1;     // 
    wire[7:0] parallelOut;  // Current Shift Register Values
    wire res_sel;             // Select between display options
    wire parallelslc;         // select parallel input
    wire serialin;            // binary input for serial input
	wire serialout;           // serial output of shift register
    wire posSCLK;             // clk edge for serial input
    wire negSCLK;			  // 
    wire CS ;				  // chip select
    wire Flag; 				  // R/W flag
    wire miso_buff;			  // miso_buff
    wire dm_we;				  // dm_we
    wire addr_we;			  // addr_we
    wire sr_we;				  // sr_we
	wire output_ff_out;        // output ff output
	wire miso;
    

    //Map to input conditioners noisy signal sw[0]...sw[2]
	//(clk,noisysignal,conditioned,positiveedge,negativeedge);
    inputconditioner MOSI_conditioner(.clk(clk),.conditioned(serialin),.noisysignal(sw[0]));
    inputconditioner SCLK(.clk(clk),.noisysignal(sw[1]),.positiveedge(posSCLK),.negativeedge(negSCLK));
    inputconditioner CS_conditioner(.clk(clk),.conditioned(CS),.noisysignal(sw[2]));

    //finite statemachine
	//(MISO_BUFF,DM_WE,ADDR_WE,SR_WE,POS_EDGE,CS,shiftRegOutP0,clk)
    fsm fsm_process(.MISO_BUFF(miso_buff),.DM_WE(dm_we),.ADDR_WE(addr_we),.SR_WE(sr_we),.POS_EDGE(posSCLK),.CS(CS),.shiftRegOutP0(parallelOut[0]),.clk(clk));

    //Address Latch 
    dlatch addr_latch(.data(parallelOut),.clk(clk),.addr_we(addr_we),.addr(address));

	dff output_ff(.trigger(clk),.enable(negSCLK),.d(serialout),.q(output_ff_out));
	
	tristatebuffer outbuffer(.out(miso_pin),.in(output_ff_out),.en(miso_buff));

    //(clk,peripheralClkEdge,parallelLoad,parallelDataIn,serialDataIn,parallelDataOut,serialDataOut)
    shiftregister shifted(.clk(clk),.peripheralClkEdge(posSCLK),.parallelLoad(sr_we),.parallelDataIn(parallelData),.serialDataIn(serialin),.parallelDataOut(parallelOut),.serialDataOut(serialout));

    //data memory
	//clk,dataOut,address,writeEnable,dataIn
    datamemory data(.clk(clk),.dataOut(parallelData),.address(address),.writeEnable(dm_we),.dataIn(parallelOut));



    // Assign bits of shiftregister to appropriate display boxes
    initial begin
	    if (miso) begin
			led[0] <= 1;
		end else if (miso === 1'bz ) begin
            led[3] <= 1 ;
        end
    end
endmodule