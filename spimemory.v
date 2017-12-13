`include "fsm.v"
`include "datamemory.v"

//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//  Wrapper for Lab 2: Midpoint.v
// 
//  Rationale: 
//     The ZYBO board has 4 buttons, 4 switches, and 4 LEDs. But if we want to
//     show the results of a 4-bit add operation, we will need at least 6 LEDs!
//
//     This wrapper module allows for 4-bit operands to be loaded in one at a
//     time, and multiplexes the LEDs to show the SUM and carryout/overflow at
//     different times.
//
//
//  Usage:
//     btn0 - load parallel load into input conditioner -> shift register
//     btn1 - show first 4 bits
//     btn2 - show last 4 bits
//     sw0 - Serial In Input into input conditioner -> shift register
//     sw1 - Clk Edge
//
//     Note: Buttons, switches, and LEDs have the least-significant (0) position
//     on the right.      
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Basic building block modules
//--------------------------------------------------------------------------------

// JK flip-flop
module jkff1
(
    input trigger,
    input j,
    input k,
    output reg q
);
    always @(posedge trigger) begin
        if(j && ~k) begin
            q <= 1'b1;
        end
        else if(k && ~j) begin
            q <= 1'b0;
        end
        else if(k && j) begin
            q <= ~q;
        end
    end
endmodule

module tristatebuffer(out,in,en);
    input in;
    input en;
    output out;
    
    assign out = en ? in : 1'bz;
    
endmodule

// Two-input MUX with parameterized bit width (default: 1-bit)
module mux2 #( parameter W = 1 )
(
    input[W-1:0]    in0,
    input[W-1:0]    in1,
    input           sel,
    output[W-1:0]   out
);
    // Conditional operator - http://www.verilog.renerta.com/source/vrg00010.htm
    assign out = (sel) ? in1 : in0;
endmodule

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
        addr <= data[7:1];
    end 
end

endmodule

//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

module inputconditioner
(clk,noisysignal,conditioned,positiveedge,negativeedge);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 1;     // Debounce delay, in clock cycles

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


//--------------------------------------------------------------------------------
// Main Lab 2 wrapper module
//   Interfaces with switches, buttons, and LEDs on ZYBO board. Allows for two
//   operations: read and write. 8 bits are entered (first 7 are address and the last is a R/W flag)
//   Read:
//   Write: 
//--------------------------------------------------------------------------------

module spiMemory(clk,sclk_pin,cs_pin,miso_pin,mosi_pin,leds,buffered_serialin,posSCLK,CS,miso_buff,shiftRegOutP,parallelOut,parallelData,sr_we,dm_we,state,conditioned_clk,counter,output_ff_out,addr_we,relevant_shiftRegOutP0,address,clk_counter);
    input clk;
    input sclk_pin;
    input cs_pin;
    output miso_pin;
    input mosi_pin;
    output [3:0] leds;
	output buffered_serialin;
	output posSCLK;
	output CS;
	output miso_buff;
	output shiftRegOutP;
	output [7:0] parallelOut;
	output [7:0] parallelData;
	output sr_we;
	output dm_we;
	output [1:0] state;
	output conditioned_clk;
	output [4:0] counter;
	output output_ff_out;
	output addr_we;
	output [1:0] relevant_shiftRegOutP0;
	output [6:0] address;
	output [5:0] clk_counter;
    output serialin;
    output posSCLK;
    output CS;
    output miso_buff;
    output shiftRegOutP;
    output [7:0] parallelOut;
    output [7:0] parallelData;
    output sr_we;

    wire[7:0] parallelData;   // ParallelData Out
    wire[6:0] address;        // address
    wire[7:0] parallelOut;    // Current Shift Register Values
    wire res_sel;             // Select between display options
    wire parallelslc;         // select parallel input
    wire serialin;            // binary input for serial input
    wire serialout;           // serial output of shift register
    wire posSCLK;             // clk edge for serial input
    wire negSCLK;             // 
    wire CS ;                 // chip select
    wire Flag;                // R/W flag 
    wire miso_buff;           // miso_buff
    wire dm_we;               // dm_we
    wire addr_we;             // addr_we
    wire sr_we;               // sr_we
    wire output_ff_out;       // output ff output
    wire filler;              // filler wire
	wire shiftRegOutP;
	wire [1:0] state;
	wire conditioned_clk;
	wire [4:0] counter;
    wire buffered_serialin;
	wire buffered_posSCLK;
	wire [1:0] relevant_shiftRegOutP0;
	wire miso_buff_d2,miso_buff_d1,dm_we_d2,dm_we_d1,addr_we_d2,addr_we_d1,sr_we_d2,sr_we_d1;
	wire [5:0] clk_counter;
	wire clk;
    
    assign shiftRegOutP = parallelOut[0];
    
    //Map to input conditioners
    //(clk,noisysignal,conditioned,positiveedge,negativeedge);
    inputconditioner MOSI_conditioner(.clk(clk),.noisysignal(mosi_pin),.conditioned(serialin),.positiveedge(filler),.negativeedge(filler));
    inputconditioner SCLK(.clk(clk),.noisysignal(sclk_pin),.conditioned(conditioned_clk),.positiveedge(posSCLK),.negativeedge(negSCLK));
    inputconditioner CS_conditioner(.clk(clk),.noisysignal(cs_pin),.conditioned(CS),.positiveedge(filler),.negativeedge(filler));

    //finite statemachine
    //(MISO_BUFF,DM_WE,ADDR_WE,SR_WE,POS_EDGE,CS,shiftRegOutP0,clk)
    fsm fsm_process(.MISO_BUFF(miso_buff),.DM_WE(dm_we),.ADDR_WE(addr_we),.SR_WE(sr_we),.POS_EDGE(posSCLK),.CS(CS),.shiftRegOutP0(parallelOut[0]),.clk(clk),.state(state),.counter(counter),.relevant_shiftRegOutP0(relevant_shiftRegOutP0),.clk_counter(clk_counter));

	//dff miso_buff_buffer2(.trigger(clk),.enable(1'b1),.d(miso_buff_d2),.q(miso_buff_d1));
	//dff mis_buff_buffer1(.trigger(clk),.enable(1'b1),.d(miso_buff_d1),.q(miso_buff));
	
	//dff dm_we_buffer2(.trigger(clk),.enable(1'b1),.d(dm_we_d2),.q(dm_we_d1));
	//dff dm_we_buffer1(.trigger(clk),.enable(1'b1),.d(dm_we_d1),.q(dm_we));
	
	//dff addr_we_buffer2(.trigger(clk),.enable(1'b1),.d(addr_we_d2),.q(addr_we_d1));
	//dff addr_we_buffer1(.trigger(clk),.enable(1'b1),.d(addr_we_d1),.q(addr_we));
	
	//dff sr_we_buffer2(.trigger(clk),.enable(1'b1),.d(sr_we_d2),.q(sr_we_d1));
	//dff sr_we_buffer1(.trigger(clk),.enable(1'b1),.d(sr_we_d1),.q(sr_we));
	
	dff serialin_buffer(.trigger(posSCLK),.enable(1'b1),.d(serialin),.q(buffered_serialin));
    //Address Latch 
    dlatch addr_latch(.data(parallelOut),.clk(clk),.addr_we(addr_we),.addr(address));

    dff output_ff(.trigger(clk),.enable(negSCLK),.d(serialout),.q(output_ff_out));
    
    tristatebuffer outbuffer(.out(miso_pin),.in(output_ff_out),.en(miso_buff));

    //(clk,peripheralClkEdge,parallelLoad,parallelDataIn,serialDataIn,parallelDataOut,serialDataOut)
    shiftregister shifted(.clk(clk),.peripheralClkEdge(posSCLK),.parallelLoad(sr_we),.parallelDataIn(parallelData),.serialDataIn(buffered_serialin),.parallelDataOut(parallelOut),.serialDataOut(serialout));

    //data memory
    //clk,dataOut,address,writeEnable,dataIn
    datamemory data(.clk(clk),.dataOut(parallelData),.address(address),.writeEnable(dm_we),.dataIn(parallelOut));

endmodule