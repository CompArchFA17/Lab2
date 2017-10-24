// Top-level module for the midpoint check-in
// Uses shift registers and input conditioners

`include "inputconditioner.v"
`include "shiftregister.v"

module midpoint
(
	input				clk,
	input				button0,
	input 				switch0,
	input				switch1,
	input [7:0]			parallelIn,
	output [7:0]		ledState
);

	// Input Conditioner for Button 0

	wire b0_conditioned;
	wire b0_positiveedge;
	wire b0_negativeedge;

	inputconditioner b0(clk, button0, b0_conditioned, b0_positiveedge, b0_negativeedge);

	// Input Conditioner for Switch 0

	wire s0_conditioned;
	wire s0_positiveedge;
	wire s0_negativeedge;

	inputconditioner s0(clk, switch0, s0_conditioned, s0_positiveedge, s0_negativeedge);

	// Input Conditioner for Switch 1

	wire s1_conditioned;
	wire s1_positiveedge;
	wire s1_negativeedge;

	inputconditioner s1(clk, switch1, s1_conditioned, s1_positiveedge, s1_negativeedge);

	// Shift register
	wire sr_serialOut;

	shiftregister sr(clk, s1_positiveedge, b0_negativeedge, parallelIn, s0_conditioned, ledState, sr_serialOut);

endmodule 