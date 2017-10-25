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
// Main Lab 0 wrapper module
//   Interfaces with switches, buttons, and LEDs on ZYBO board. Allows for two
//   4-bit operands to be stored, and two results to be alternately displayed
//   to the LEDs.
//--------------------------------------------------------------------------------

module midpoint
(
    input        clk,
    input  [1:0] sw,
    input  [2:0] btn,
    output [3:0] led
);

    reg[7:0] parallelData = 8'b11000011; //Assign default parallel in
    wire[3:0] res0, res1;     // 
    wire[7:0] shiftregister;  // Current Shift Register Values
    wire res_sel;             // Select between display options
    wire parallelslc;         // select parallel input
    wire serialin;            // binary input for serial input
    wire serialclk;           // clk edge for serial input

    
    // Capture button input to switch which MUX input to LEDs
    jkff1 src_sel(.trigger(clk), .j(btn[1]), .k(btn[2]), .q(res_sel));
    mux2 #(4) output_select(.in0(res0), .in1(res1), .sel(res_sel), .out(led));
    
    //Map to input conditioner
    inputconditioner parallel(.noisysignal(btn[0]),.clk(clk),.negativeedge(parallelslc));
    inputconditioner serialinputs(.noisysignal(sw[0]),.clk(clk),.conditioned(serialin));
    inputconditioner serialclocks(.noisysignal(sw[1]),.clk(clk),.positiveedge(serialclk));

    //Input into Shift Register
    shiftregister shifted(.clk(clk),.peripheralClkEdge(serialclk),.parallelLoad(parallelslc),.parallelDataIn(parallelData),.serialDataIn(serialin),.parallelDataOut(shiftregister));


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
