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


// D flip-flop with parameterized bit width (default: 1-bit)
// Parameters in Verilog: http://www.asic-world.com/verilog/para_modules1.html
module dff #( parameter W = 1 )
(
    input trigger,
    input enable,
    input      [W-1:0] d,
    output reg [W-1:0] q
);
    always @(posedge trigger) begin
        if(enable) begin
            q <= d;
        end 
    end
endmodule

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




module lab2_wrapper
(
	input clk,

    input  [3:0] sw,        // Built-in switches, used for input opA
    //input  [3:0] ja_p,      // Don't think we need this
    input  [3:0] btn,
    output [3:0] led,       // Built-in LED, used to display opA for sanity checking
    output [7:0] je         // Plug LD8 into JE, used to display sum, cout, overflow
);

	//wire serialDataIn;
	//wire peripheralClkEdge;
    wire [7:0] parallelDataIn;
    wire serialOut;
    wire[7:0] res;
    assign parallelDataIn = 8'b10010011;

    // Assign logical signals to physical ports (change these if you move the Pmods)
    //assign serialDataIn = sw[0];
	//assign peripheralClkEdge = sw[1];
	//assign button = btn[0];
    assign je[7:0] = res;    
	assign serialOut = led[0];
       
    // TODO: You write the body of your FullAdder4bit module in adder.v

	midpoint mid(.switch0(sw[0]), .switch1(sw[1]), .button(btn[0]), .clk(clk), .parallelDataIn(parallelDataIn), .parallelDataOut2(res), .serialDataOut(serialOut));


endmodule








