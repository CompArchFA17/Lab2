`include "spimemory.v"

module testspimemory();
	reg           clk = 0;        // FPGA clock
    reg           sclk_pin = 0;   // SPI clock
    reg           cs_pin;     // SPI chip select
    wire          miso_pin;   // SPI master in slave out, has memory address
    reg           mosi_pin;   // SPI master out slave in, for reading
    wire [3:0]     leds;		  // leds
    reg [15:0]    data; 	  // data
	wire buffered_serialin;
	wire posSCLK;
	wire CS;
	wire miso_buff;
	wire shiftRegOutP;
	wire [7:0] parallelOut;
	wire [7:0] parallelData;
	wire sr_we;
	wire dm_we;
	wire [1:0] state;
	wire conditioned_clk;
	wire [4:0] counter;
	wire output_ff_out;
	wire addr_we;
	wire [1:0] relevant_shiftRegOutP0;
	wire [6:0] address;
	wire [5:0] clk_counter;

    spiMemory dut(.clk(clk),
    				.sclk_pin(sclk_pin),
    				.cs_pin(cs_pin),
    				.miso_pin(miso_pin),
    				.mosi_pin(mosi_pin),
    				.leds(leds),
					.buffered_serialin(buffered_serialin),
					.posSCLK(posSCLK),
					.CS(CS),
					.miso_buff(miso_buff),
					.shiftRegOutP(shiftRegOutP),
					.parallelOut(parallelOut),
					.parallelData(parallelData),
					.sr_we(sr_we),
					.dm_we(dm_we),
					.state(state),
					.conditioned_clk(conditioned_clk),
					.counter(counter),
					.output_ff_out(output_ff_out),
					.addr_we(addr_we),
					.relevant_shiftRegOutP0(relevant_shiftRegOutP0),
					.address(address),
					.clk_counter(clk_counter)
    			);

	initial begin
       forever begin
          clk = !clk; #1;
       end
    end    // 50MHz Clock
	initial begin
       forever begin
          sclk_pin = !sclk_pin; #10;
       end
    end
	
	initial begin
		cs_pin = 1; #500

		//Test Case 1: Write: Address: 00000010 Data: 111111111

		$display ("Initialize Testing");
		data = 16'b0000001011111111;

		cs_pin = 0; #20

		mosi_pin = data[15]; #20
		mosi_pin = data[14]; #20
		mosi_pin = data[13]; #20
		mosi_pin = data[12]; #20
		mosi_pin = data[11]; #20
		mosi_pin = data[10]; #20
		mosi_pin = data[9]; #20

		mosi_pin = 0; #20 

		mosi_pin = data[7]; #20
		mosi_pin = data[6]; #20
		mosi_pin = data[5]; #20
		mosi_pin = data[4]; #20
		mosi_pin = data[3]; #20
		mosi_pin = data[2]; #20
		mosi_pin = data[1]; #20
		mosi_pin = data[0]; #20
		
		//checkSPI spi_case1(.data(16'b0000001011111111),.clk(clk),.slck(slck),.cs_pin(cs_pin),.mosi_pin(mosi_pin));

		#500

		cs_pin = 1; #600

		// TestCase 2: Read: Address: 00000010 
		
		cs_pin = 0; #20

		data = 16'b0000001111111111;

		mosi_pin = data[15]; #20
		mosi_pin = data[14]; #20
		mosi_pin = data[13]; #20
		mosi_pin = data[12]; #20
		mosi_pin = data[11]; #20
		mosi_pin = data[10]; #20
		mosi_pin = data[9]; #20
		
		mosi_pin = 1; #20
		
		if ((miso_pin != data[7])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != data[6])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != data[5])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != data[4])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != data[3])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != data[2])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != data[1])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != data[0])) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		#500
		//checkSPI spi_case2(.data(16'b0000001111111111),.clk(clk),.slck(slck),.cs_pin(cs_pin),.mosi_pin(mosi_pin));
        cs_pin = 1; #600
		cs_pin = 0; #20

		// TestCase 3: Read other Address: 000000101 
		// Check to make sure that our Write didnt write to other parts

		data = 16'b0000010111111111;

		mosi_pin = data[15]; #20
		mosi_pin = data[14]; #20
		mosi_pin = data[13]; #20
		mosi_pin = data[12]; #20
		mosi_pin = data[11]; #20
		mosi_pin = data[10]; #20
		mosi_pin = data[9]; #20
		
		mosi_pin = 1; #20
		
		$display ("Testing ongoing");
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != 0)) $display ("Test Failed at Read Element 1: %b ", miso_pin); #20
		if ((miso_pin != 1)) begin $display ("Test Failed at Read Element 1: %b ", miso_pin); end #20;

		//checkSPI spi_case2(.data(16'b0000001111111111),.clk(clk),.slck(slck),.cs_pin(cs_pin),.mosi_pin(mosi_pin));
	end

endmodule