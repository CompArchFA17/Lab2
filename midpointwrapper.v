//--------------------------------------------------------------------------------
//  Wrapper for Lab 2: Midpoint Check
// 
//  Rationale:
//      This wrapper module allows for testing the PIPO and SIPO functionality of
//      the shift register with conditioned inputs.
//  
//  Usage:
//      btn0 - load a constant value 8'b10100101 to the shift register
//      btn1 - Display the 4 least significant bits of the Parallel Out port
//      btn2 - Display the 4 most significant bits of the Parallel Out port
//      sw0 - toggle the serial input between low and high
//      sw1 - toggle to shift the serial input to the LSB of the shift register
//
//      Note: Buttons, switches, and LEDs have the least-significant (0) position
//      on the right.      
//--------------------------------------------------------------------------------

`timescale 1ns / 1ps
`include "midpoint.v"


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
//
//   You must write the FullAdder4bit (in your adder.v) to complete this module.
//   Challenge: write your own interface module instead of using this one.
//--------------------------------------------------------------------------------

module lab0_wrapper
(
    input        clk,
    input  [1:0] sw,
    input  [1:0] btn,
    output [3:0] led
);

    wire[7:0] res;            // Full parallel output of shift register
    wire[3:0] res0, res1;     // Output display options: 4 most or 4 least significant bits
    wire res_sel;             // Select between display options
    
    // Capture button input to switch which MUX input to LEDs
    jkff1 src_sel(.trigger(clk), .j(btn[2]), .k(btn[1]), .q(res_sel));
    mux2 #(4) output_select(.in0(res0), .in1(res1), .sel(res_sel), .out(led));

    parameter parallelIn = 8'hA5;
    midpoint mid (.clk(clk), .button0(btn[0]), .switch0(sw[0]), .switch1(sw[1]), .parallelIn(parallelIn), .ledState(res));

    // Assign bits of second display output to show carry out and overflow
    assign res0[0] = res[0];
    assign res0[1] = res[1];
    assign res0[2] = res[2];
    assign res0[3] = res[3];
    assign res1[0] = res[4];
    assign res1[1] = res[5];
    assign res1[2] = res[6];
    assign res1[3] = res[7];
    
endmodule