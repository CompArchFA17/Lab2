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

`timescale 1ns / 1ps

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
	input [7:0] in;
	input en;
	output [7:0] out;
	
	assign out = en ? in : 8'b0;
	
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
	always @p(posedge trigger) begin
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
	output [6:0] addr
);

reg [6:0] addr;

always @(posedge clk) begin
	if(addr_we) begin
		assign addr = data[7:1];
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
    if(conditioned == 0 && conditioned1 == 1) begin
        negativeedge = 1;
    end else if (conditioned == 1 && conditioned1 == 0) begin
        positiveedge = 1;
        end else if (positiveedge == 1 || negativeedge == 1) begin
            positiveedge = 0;
            negativeedge = 0;
        end
        if(conditioned == synchronizer1)
            counter <= 0;
        else begin
            if( counter == waittime) begin
                counter <= 0;
                conditioned <= synchronizer1;
            end
            else 
                counter <= counter+1;
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
    conditioned1 <= conditioned;
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

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
)

	integer i; 
    wire[7:0] parallelData    // ParallelData Out
    wire[6:0] address 		  // address
    wire[3:0] res0, res1;     // 
    wire[7:0] shiftregister;  // Current Shift Register Values
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
	wire output_ff_out        // output ff output
    
    //Map to input conditioners
    inputconditioner MOSI(.noisysignal(mosi_pin),.clk(clk),.conditioned(serialin));
    inputconditioner SCLK(.noisysignal(sclk_pin),.clk(clk),.positiveedge(posSCLK),.negativeedge(negSCLK));
    inputconditioner CS(.noisysignal(cs_pin),.clk(clk),.conditioned(CS));

    //finite statemachine
    fsm(.POS_EDGE(posSCLK),.CS(CS),.shiftRegOutP0(Flag),.MISO_BUFF(miso_buff),.DM_WE(dm_we),.ADDR_WE(sr_we),.SR_WE(sr_we));

    //Address Latch 
    dlatch addr_latch(.data(parallelData),.clk(clk),.addr_we(addr_we),.addr(address));

	dff output_ff(.trigger(clk),.enable(negSCLK),.d(serialout),.q(output_ff_out));
	
	tristatebuffer outbuffer(.out(miso_pin),.in(output_ff_out),.en(miso_buff));
 	//Wait for chip select to be asserted low and begin
 	always @(posedge clk) begin
 		If()

    //Read first 8 bits
    for (i = 7; i > 0; i = i-1) begin
    	assign serialin
    end

    shiftregister shifted(.clk(clk),.peripheralClkEdge(posSCLK),.parallelLoad(parallelslc),.parallelDataIn(parallelData),.serialDataIn(serialin),.parallelDataOut(shiftregister));


    //Write Operation


    shiftregister shifted(.clk(clk),.peripheralClkEdge(posSCLK),.parallelLoad(parallelslc),.parallelDataIn(parallelData),.serialDataIn(serialin),.parallelDataOut(shiftregister));

    //data memory
    datamemory data(.clk(clk),.address(address),.writeEnable(dm_we),.dataIn(shiftregister));

    //Input into Shift Register


	//Read Operation

    shiftregister shifted(.clk(clk),.peripheralClkEdge(posSCLK),.parallelLoad(parallelslc),.parallelDataIn(d_out),.serialDataOut(serialout));

    //data memory
    datamemory data(.clk(clk),.dataOut(),.address(),.writeEnable(dm_we));





    // Assign bits of shiftregister to appropriate display boxes
    assign res0[0] = shiftregister[0];
    assign res0[1] = shiftregister[1];
    assign res0[2] = shiftregister[2];
    assign res0[3] = shiftregister[3];
    assign res1[0] = shiftregister[4];
    assign res1[1] = shiftregister[5];
    assign res1[2] = shiftregister[6];
    assign res1[3] = shiftregister[7];

endmodule
   
