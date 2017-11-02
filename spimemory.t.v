`include "spimemory.v"

module testspimemory ();
	reg mosi_pin;
	reg sclk;
	reg cs;
	reg clk;
	wire miso_pin;

	spimemory dut (clk, sclk, cs, miso_pin, mosi_pin);

	initial clk = 0;
	always #10 clk = !clk;

	initial begin
		$dumpfile("spimemory.vcd");
		$dumpvars(0, testspimemory, dut.dm.memory[0], dut.dm.memory[1]);

		// One cycle to get to first state
		cs = 1;	// keep cs high until in state
		sclk = 0; #1000
		sclk = 1; #1000

		// Start presenting address bits 7'b1010101
		cs = 0;
		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		// Indicate write state
		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		// Start presenting data bits 8'b 10101010
		sclk = 0; mosi_pin = 1; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 1; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 1; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 1; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		// Chip select goes high.
		sclk = 0; cs = 1; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		// Chip select goes low.
		// Start presenting address bits '7b 1010101
		cs = 0;
		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		// Indicate read state
		sclk = 0; mosi_pin = 1; #1000
		sclk = 1; #1000

		// Cycle through to push all data to serialOut
		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		cs = 1;

		sclk = 0; #1000
		sclk = 1; #1000
		

		// // Data to write
		// mosi_pin = 1;
		// sclk = 0; #1000
		// sclk = 1; #1000

		// sclk = 0; #1000
		// sclk = 1; #1000

		// sclk = 0; #1000
		// sclk = 1; #1000

		// sclk = 0; #1000
		// sclk = 1; #1000

		// sclk = 0; #1000
		// sclk = 1; #1000

		// sclk = 0; #1000
		// sclk = 1; #1000

		// sclk = 0; #1000
		// sclk = 1; #1000

		// sclk = 0; #1000
		// sclk = 1; #1000




		$finish();
		
	end
endmodule