//------------------------------------------------------------------------
// SPI Memory
// 		Memory operations happen when chip select is low.
//		Memory can be both read from and written to using
//		standard spi protocol.
//------------------------------------------------------------------------

`include "inputconditioner.v"
`include "shiftregister.v"
`include "fsm.v"
`include "datamemory.v"
`include "addresslatch.v"
`include "dflipflop.v"

module spimemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin//,   // SPI master out slave in
);

	// mosi input conditioner wires

	wire mosi_ic_conditioned;
	wire mosi_ic_positiveedge;
	wire mosi_ic_negativeedge;

	// sclk input conditioner wires

	wire sclk_ic_conditioned;
	wire sclk_ic_positiveedge;
	wire sclk_ic_negativeedge;

	// chip select input conditioner wires

	wire cs_ic_conditioned;
	wire cs_ic_positiveedge;
	wire cs_ic_negativeedge;

	// finite state machine wires

	wire miso_buff;
	wire dm_we;
	wire addr_we;
	wire sr_we;

	// data memory wires

	wire [7:0] dataMemOut;

	// shift register wires

	wire [7:0] sr_parallelDataOut;
	wire sr_serialDataOut;

	// address latch wires

	wire [6:0] address;

	// d flip flop wires

	wire q;


	//  input conditioner blocks for mosi, sclk, and chip select

	inputconditioner mosi_ic(clk, mosi_pin, mosi_ic_conditioned, mosi_ic_positiveedge, mosi_ic_negativeedge);

	inputconditioner sclk_ic(clk, sclk_pin, sclk_ic_conditioned, sclk_ic_positiveedge, sclk_ic_negativeedge);

	inputconditioner cs_ic(clk, cs_pin, cs_ic_conditioned, cs_ic_positiveedge, cs_ic_negativeedge);


	// finite state machine

	fsm fsm(sclk_ic_positiveedge, cs_ic_conditioned, sr_parallelDataOut[0], miso_buff, dm_we, addr_we, sr_we);


	// data memory
	
	datamemory dm(clk, dataMemOut, address, dm_we, sr_parallelDataOut);


	// shift register

	shiftregister sr(clk, sclk_ic_positiveedge, sr_we, dataMemOut, mosi_ic_conditioned, sr_parallelDataOut, sr_serialDataOut);


	// address latch

	addresslatch al(sr_parallelDataOut[7:1], addr_we, clk, address);


	// d-flip flop

	dflipflop dff(sr_serialDataOut, sclk_ic_negativeedge, clk, q);

	// miso buffer

	bufif1 buf1(miso_pin, q, miso_buff);

endmodule
   
