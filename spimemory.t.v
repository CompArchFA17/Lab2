`include "spimemory.v"

module testspimemory();
	reg           clk;        // FPGA clock
    reg           sclk_pin;   // SPI clock
    reg           cs_pin;     // SPI chip select
    wire          miso_pin;   // SPI master in slave out, has memory address
    reg           mosi_pin;   // SPI master out slave in, for reading
    wire [3:0]     leds;		  // leds
    reg [15:0]    data; 	  // data

    spiMemory dut(.clk(clk),
    				.sclk_pin(sclk_pin),
    				.cs_pin(cs_pin),
    				.miso_pin(miso_pin),
    				.mosi_pin(mosi_pin),
    				.leds(leds)
    			);

    // generating the clock and initialize system
    initial begin
    	sclk_pin = 0;
		clk=0;
	end
	always #5 clk=!clk;    // 50MHz Clock
	always #50 sclk_pin=!sclk_pin;
	
	initial begin


		cs_pin = 1; #500

		//Test Case 1: Write: Address: 00000010 Data: 111111111

		$display ("Initialize Testing");
		data = 16'b0000001011111111;

		cs_pin = 0; #100

		mosi_pin = data[15]; #100
		mosi_pin = data[14]; #100
		mosi_pin = data[13]; #100
		mosi_pin = data[12]; #100
		mosi_pin = data[11]; #100
		mosi_pin = data[10]; #100
		mosi_pin = data[9]; #100

		mosi_pin = data[8]; #100 

		mosi_pin = data[7]; #100
		mosi_pin = data[6]; #100
		mosi_pin = data[5]; #100
		mosi_pin = data[4]; #100
		mosi_pin = data[3]; #100
		mosi_pin = data[2]; #100
		mosi_pin = data[1]; #100
		mosi_pin = data[0]; #100
		
		//checkSPI spi_case1(.data(16'b0000001011111111),.clk(clk),.slck(slck),.cs_pin(cs_pin),.mosi_pin(mosi_pin));

		#100

		cs_pin = 1; #600

		// TestCase 2: Read: Address: 00000011 

		data = 16'b0000001111111111;

		mosi_pin = data[15]; #100
		mosi_pin = data[14]; #100
		mosi_pin = data[13]; #100
		mosi_pin = data[12]; #100
		mosi_pin = data[11]; #100
		mosi_pin = data[10]; #100
		mosi_pin = data[9]; #1001
		
		mosi_pin = data[8]; #100 
		
		if ((miso_pin != data[7])) begin $display ("Test Failed at Read Element 1: %b ", miso_pin); end #100
		if ((miso_pin != data[6])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != data[5])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != data[4])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != data[3])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != data[2])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != data[1])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != data[0])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		//checkSPI spi_case2(.data(16'b0000001111111111),.clk(clk),.slck(slck),.cs_pin(cs_pin),.mosi_pin(mosi_pin));

		cs_pin = 0; #100

		// TestCase 3: Read other Address: 000000101 
		// Check to make sure that our Write didnt write to other parts

		data = 16'b0000010111111111;

		mosi_pin = data[15]; #100
		mosi_pin = data[14]; #100
		mosi_pin = data[13]; #100
		mosi_pin = data[12]; #100
		mosi_pin = data[11]; #100
		mosi_pin = data[10]; #100
		mosi_pin = data[9]; #100
		
		mosi_pin = data[8]; #100 
		
		$display ("Testing ongoing");
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #100
		if ((miso_pin != 1)) begin $display ("Test Failed at Read Element 1: %b ", miso_pin); end #100

		//checkSPI spi_case2(.data(16'b0000001111111111),.clk(clk),.slck(slck),.cs_pin(cs_pin),.mosi_pin(mosi_pin));
		#100 $finish;
	end

endmodule




