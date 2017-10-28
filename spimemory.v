//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "inputconditioner.v"
`include "shiftregister.v"

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
)
	wire conditionedInput1, conditionedInput2;
	wire positiveEdge, negativeEdge;
	inputcondition condition1(clk, miso_pin, conditioned, ,);
	inputcondition condition1(clk, sclk_pin, , positiveEdge, negativeEdge);
	inputcondition condition1(clk, cs_pin, conditionedInput2, , );

	wire parallelOut, serialOut;
	shiftregister shiftRegister(clk, positiveEdge, sr_we, parallelDataIn, conditionedInput1, parallelOut, serialOut);

	wire q;
	dff dFF(clk, serialOut, negativeEdge, q, );
endmodule
   
