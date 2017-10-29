//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "inputconditioner.v"
`include "shiftregister.v"
`include "dff.v"
`include "datamemory.v"

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);
	reg MISO_BUFE, DM_WE, ADDR_WE, SR_WE;
	wire conditionedInput1, conditionedInput2;
	wire positiveEdge, negativeEdge;
	inputconditioner condition1(clk, miso_pin, conditioned, ,);
	inputconditioner condition2(clk, sclk_pin, , positiveEdge, negativeEdge);
	inputconditioner condition3(clk, cs_pin, conditionedInput2, , );

	wire shiftRegOutP[7:0], serialOut;
	wire dataMemoryOut[7:0], address[7:0];
	shiftregister shiftRegister(clk, positiveEdge, SR_WE, dataMemoryOut, conditionedInput1, shiftRegOutP, serialOut);

	/*dff #(8) dff1(clk, ADDR_WE, shiftRegOutP, address);
	wire q;
	dff #(1) dff2(clk, negativeEdge, serialOut, q);

	datamemory dataMemory(clk, shiftRegOutP, address, DM_WE, dataMemoryOut);*/


endmodule
   
