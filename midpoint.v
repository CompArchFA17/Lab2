// Midpoint deliverable file

`include "inputconditioner.v"
`include "shiftregister.v"

module midpoint
#(parameter width = 8)
(
input		switch0, // SerialDataIn
input 		switch1, // peripheralClkEdge
input 		button,  // ParallelLoad
input 		clk,
input [width-1:0]	parallelDataIn,
output [width-1:0] 	parallelDataOut2
output serialDataOut;
);

wire conditioned0;
wire positiveedge0;
wire negativeedge0;

wire conditioned1;
wire positiveedge1;
wire negativeedge1;

wire conditioned2;
wire positiveedge2;
wire negativeedge2;



inputconditioner parallelLoadCond(clk, button, conditioned0, positiveedge0, negativeedge0); // negativeedge0 is your cleaned up button/ParallelLoad

inputconditioner serialInCond(clk, switch0, conditioned1, positiveedge1, negativeedge1); // conditioned1 is your cleaned up SerialDataIn

inputconditioner SCLKCond(clk, switch1, conditioned2, positiveedge2, negativeedge2); // positiveedge2 is your cleaned up peripheralClkEdge

shiftregister shift(clk, positiveedge2, negativeedge0, parallelDataIn, switch0, parallelDataOut2, serialDataOut);


endmodule


