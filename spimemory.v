//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "inputconditioner.v"
`include "shiftregister.v"
`include "dff.v"
`include "datamemory.v"
`include "fsm.v"

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    input           mosi_pin,   // SPI master out slave in
    output          miso_pin,   // SPI master in slave out
    output [3:0]    leds        // LEDs for debugging
);
	wire MISO_BUFE, DM_WE, ADDR_WE, SR_WE;

	wire chip_select;
	wire sclk_pos, sclk_neg;
	inputconditioner #(1) c2(.clk(clk),
                      .noisysignal(sclk_pin),
                      .positiveedge(sclk_pos),
                      .negativeedge(sclk_neg));
	inputconditioner c3(.clk(clk),
                      .noisysignal(cs_pin),
                      .conditioned(chip_select));

	wire[7:0] shiftRegOutP, dataMemoryOut;
  wire serialOut;

  shiftregister #(8) sr(.clk(clk),
               .peripheralClkEdge(sclk_pos),
               .parallelLoad(SR_WE),
               .parallelDataIn(dataMemoryOut),
               .serialDataIn(mosi_pin),
               .parallelDataOut(shiftRegOutP),
               .serialDataOut(serialOut));

	wire[7:0] address;
	dff #(8) dff1(clk, ADDR_WE, shiftRegOutP, address);
	wire q;
	dff #(1) dff2(clk, sclk_neg, serialOut, q);

  // Tri-state buffer
  assign miso_pin = (MISO_BUFE) ? q : 1'bz;

	datamemory dataMemory(.clk(clk),
                        .dataOut(dataMemoryOut),
                        .dataIn(shiftRegOutP),
                        .address(address[7:1]),
                        .writeEnable(DM_WE));

  finiteStateMachine fsm(clk, sclk_pos, chip_select, shiftRegOut[0], MISO_BUFE, DM_WE, ADDR_WE, SR_WE);


endmodule
