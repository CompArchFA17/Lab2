//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "register.v"
`include "shiftregister.v"
`include "inputconditioner.v"
`include "datamemory.v"
`include "fsm.v"

module spiMemory
#(
    parameter width  = 8,
    parameter addresswidth = 7
)
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);

wire serialin;
wire clkedge;
wire needge;
wire chip;
wire serialout;
wire[width-1:0] dataMemOut;
wire[width-1:0] shiftRegOut;
wire[width-1:0] address;
wire DM_WE;
wire ADDR_WE;
wire SR_WE;
wire miso;

inputconditioner mosi(.clk(clk), .noisysignal(mosi_pin), .conditioned(serialin));
inputconditioner sclk(.clk(clk), .noisysignal(sclk_pin), .positiveedge(clkedge), .negativeedge(nedge));
inputconditioner cs(.clk(clk), .noisysignal(cs_pin), .conditioned(chip));
shiftregister shift(.clk(clk), .peripheralClkEdge(clkedge), .parallelLoad(SR_WE),
					.parallelDataIn(dataMemOut), .serialDataIn(serialin),
					.parallelDataOut(shiftRegOut), .serialDataOut(serialout));
register dff(.q(miso_pin), .d(serialout), .wrenable(nedge), .clk(clk));
datamemory memory(.clk(clk), .dataOut(dataMemOut), .address(address[addresswidth:1]),
                  .writeEnable(DM_WE), .dataIn(shiftRegOut));
addresslatch latch(.q(address), .d(shiftRegOut), .wrenable(ADDR_WE), .clk(clk));
fsm spifsm( .lsb(shiftRegOut[0]), .chipSelect(chip), .clk(sclk_pin),
			.sr_we(SR_WE), .addr_we(ADDR_WE), .dm_we(DM_WE));

endmodule
   