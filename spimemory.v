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
    input           mosi_pin,   // SPI master out slave in
    output          miso_pin,   // SPI master in slave out
    output [3:0]    leds        // LEDs for debugging
);
	reg MISO_BUFE, DM_WE, ADDR_WE, SR_WE;
	wire conditionedInput1, conditionedInput2;
	wire positiveEdge, negativeEdge;
	inputconditioner condition1(clk, miso_pin, conditioned, ,);
	inputconditioner condition2(clk, sclk_pin, , positiveEdge, negativeEdge);
	inputconditioner condition3(clk, cs_pin, conditionedInput2, , );

	wire[7:0] shiftRegOutP, dataMemoryOut;
  wire serialOut;

  shiftregister #(8) sr(.clk(clk),
                 .peripheralClkEdge(positiveEdge),
                 .parallelLoad(SR_WE),
                 .parallelDataIn(dataMemoryOut),
                 .serialDataIn(conditionedInput1),
                 .parallelDataOut(shiftRegOutP),
                 .serialDataOut(serialOut));

  wire[7:0] address;
	dff #(8) dff1(clk, ADDR_WE, shiftRegOutP, address);
	wire q;
	dff #(1) dff2(clk, negativeEdge, serialOut, q);

	// datamemory dataMemory(clk, shiftRegOutP, address, DM_WE, dataMemoryOut);


endmodule
