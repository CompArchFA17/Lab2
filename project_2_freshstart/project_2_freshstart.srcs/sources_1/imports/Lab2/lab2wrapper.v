//--------------------------------------------------------------------------------
//  Wrapper for Lab 0: Full Adder
// 
//  Rationale: 
//     The ZYBO board has 4 buttons, 4 switches, and 4 LEDs. 
//
//     This wrapper module allows for one bit to be loaded in at a time and to then show all data at once
//
//
//  Usage:
//     btn0 - Parallel Load
//     sw0 - SerialIn
//     sw1 - SCLCK
//
//     Note: Buttons, switches, and LEDs have the least-significant (0) position
//     on the right.      
//--------------------------------------------------------------------------------

`timescale 1ns / 1ps
`include "midpoint.v"


module lab2_wrapper
(
	input clk,
    input  [3:0] sw,        // Built-in switches, used for input opA
    input  [3:0] btn,
    output [3:0] led,       // Built-in LED, used to display opA for sanity checking
    output [7:0] je         // Plug LD8 into JE, used to display sum, cout, overflow
);

    wire [7:0] parallelDataIn;
    wire serialOut;
    wire[7:0] res;
    assign parallelDataIn = 8'b10010011;
    assign je[7:0] = res;    
	assign serialOut = led[0];

	midpoint mid(.switch0(sw[0]), .switch1(sw[1]), .button(btn[0]), .clk(clk), .parallelDataIn(parallelDataIn), .parallelDataOut2(res), .serialDataOut(serialOut));

endmodule








