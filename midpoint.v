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
//  Your job:
/
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

    reg[7:0] parallaData = 8`b11000011; //Assign default parallel in
    wire[3:0] res0, res1;     // 
    wire[7:0] shiftregister;  // Current Shift Register Values
    wire res_sel;             // Select between display options
    wire parallelslc;         // select parallel input
    wire serialin;            // binary input for serial input
    wire serialclk;           // clk edge for serial input

    
    // Capture button input to switch which MUX input to LEDs
    jkff1 src_sel(.trigger(clk), .j(btn[2]), .k(btn[1]), .q(res_sel));
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
