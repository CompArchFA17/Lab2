`include "shiftregister.v"
`include "inputconditioner.v"

//  Wrapper for Lab 2

`timescale 1ns / 1ps

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



// Main Lab 2 wrapper module
//   Interfaces with switches, buttons, and LEDs on ZYBO board.

module midpoint
(
    input        clk,
    input  [3:0] sw,
    input  [3:0] btn,
    output [3:0] led
);

    wire[7:0] result;	// total output
	wire parallelLoad; 	// wire for Parallel Load of Shift Register
	wire serialIn; 		// wire for Serial Input of Shift Register
	wire clkEdge; 		// wire for Clk Edge of Shift Register
	wire[7:0] parallelIn;	// wire for Parallel Input of Shift Register

	inputconditioner conditioner1 (
		.clk(clk), .noisysignal(btn[0]),
		.negativeedge(parallelLoad)
	);

	inputconditioner conditioner2 (
		.clk(clk), .noisysignal(sw[0]),
		.conditioned(serialIn)
	);

	inputconditioner conditioner3 (
		.clk(clk), .noisysignal(sw[1]),
		.positiveedge(clkEdge)
	);

	assign parallelIn = 8'hA5;

	shiftregister sr (
		.clk(clk), .peripheralClkEdge(clkEdge), 
		.parallelLoad(parallelLoad), .parallelDataIn(parallelIn), 
		.serialDataIn(serialIn),
		.parallelDataOut(result)
	);

    mux2 #(4) output_select(.in0(result[3:0]), .in1(result[7:4]), .sel(sw[2]), .out(led));

endmodule