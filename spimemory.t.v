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
		$dumpvars();

// Address bits
		cs = 1;

		cs = 0;
		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		
// Read/Write flag
		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

// Data bits
		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		$displayb(miso_pin);

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		$displayb(miso_pin);

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		$displayb(miso_pin);

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		$displayb(miso_pin);

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		$displayb(miso_pin);

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		$displayb(miso_pin);

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		$displayb(miso_pin);

		sclk = 1; #15
		mosi_pin = 0;
		sclk = 0; #15

		$displayb(miso_pin);

		$finish();
		
	end
endmodule