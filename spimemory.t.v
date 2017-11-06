// Test Bench for full SPI memory

`include "spimemory.v"

module testSPImem();

    // inputs and outputs for function
    reg clk;
    reg spi_clk;
    reg chip_select = 1;
    wire miso;
    reg mosi = 0;
    wire[3:0] leds;

    // registers for testing
    reg[6:0] address;
    reg rw_select;
    reg[7:0] write_data;
    reg[7:0] read_data;
    wire[7:0] cmd = {address, rw_select};
    reg[3:0] i = 0;
    reg success = 1;

    spiMemory test(clk, spi_clk, chip_select, miso, mosi, leds);

    // generate clock
    initial clk = 0;
    always #1 clk = !clk; //100 MHz clock

    initial spi_clk = 0;
    always #100 spi_clk = !spi_clk; //25 MHz clock

    initial
        #200000 $finish;

    initial begin
	$dumpfile("spimemory.vcd");
	$dumpvars();
	$display("testing SPI memory");
	
// TEST 1: write data and read it back
	// initialize values to write
	address = 7'd5; // set address to 5
	write_data = 8'd155; // set write data to 155
	rw_select = 0; // write first
	#500; // wait at the beginning for fun
	@(negedge spi_clk); //wait for negative clock edge
	// start with a normal write opperation
	chip_select = 0; // select chip
	for (i=0; i<7; i=i+1) begin
	    mosi = address[6-i];
	    @(negedge spi_clk);
	end
	mosi = rw_select;
	for (i=0; i<8; i=i+1) begin
	    @(negedge spi_clk);
	    mosi = write_data[7-i];
	end
	
	// toggle chip select
	@(negedge spi_clk);
	chip_select = 1;
	@(negedge spi_clk);
	chip_select = 0;

	// read back data
	address = 7'd5; // set address to 5
	rw_select = 1; // read
	for (i=0; i<7; i=i+1) begin
	    mosi = address[6-i];
	    @(negedge spi_clk);
	end
	mosi = rw_select;
	@(negedge spi_clk);
	for (i=0; i<8; i=i+1) begin
	    @(posedge spi_clk);
	    read_data[7-i]=miso;
	end
	if (read_data != 8'd155) begin
	    $display("Test1: write data and read it back FAILED:");
	    $display("data returned is: %d", read_data);
	    success = 0;
	end
	
	// toggle chip select
	@(negedge spi_clk);
	chip_select = 1;
	@(negedge spi_clk);
	chip_select = 0;
// TEST 2: write to second address, read back from both
	// initialize values to write
	address = 7'd120; // set address to 120
	write_data = 8'd3; // set write data to 3
	rw_select = 0; // write
	// start with a normal write opperation
	for (i=0; i<7; i=i+1) begin
	    mosi = address[6-i];
	    @(negedge spi_clk);
	end
	mosi = rw_select;
	for (i=0; i<8; i=i+1) begin
	    @(negedge spi_clk);
	    mosi = write_data[7-i];
	end

	// toggle chip select
	@(negedge spi_clk);
	chip_select = 1;
	@(negedge spi_clk);
	chip_select = 0;
	
	// read back data
	address = 7'd5; // set address to 5
	rw_select = 1; // read
	for (i=0; i<7; i=i+1) begin
	    mosi = address[6-i];
	    @(negedge spi_clk);
	end
	mosi = rw_select;
	@(negedge spi_clk);
	for (i=0; i<8; i=i+1) begin
	    @(posedge spi_clk);
	    read_data[7-i]=miso;
	end
	
	if (read_data != 8'd155) begin
	    $display("Test2: write to second address, read back both FAILED:");
	    $display("data returned is: %d", read_data);
	    $display("original data has changed");
	    success = 0;
	end
	
	// toggle chip select
	@(negedge spi_clk);
	chip_select = 1;
	@(negedge spi_clk);
	chip_select = 0;
	
	// read back data
	address = 7'd120; // set address to 120
	rw_select = 1; // read
	for (i=0; i<7; i=i+1) begin
	    mosi = address[6-i];
	    @(negedge spi_clk);
	end
	mosi = rw_select;
	@(negedge spi_clk);
	for (i=0; i<8; i=i+1) begin
	    @(posedge spi_clk);
	    read_data[7-i]=miso;
	end
	
	if (read_data != 8'd3) begin
	    $display("Test2: write to second address, read back both FAILED:");
	    $display("data returned is: %d", read_data);
	    $display("new address write/read back failed");
	    success = 0;
	end

	// toggle chip select
	@(negedge spi_clk);
	chip_select = 1;
	@(negedge spi_clk);
	chip_select = 1;

// TEST 3: write new value to original address with cs disabled
	// initialize values to write
	address = 7'd5; // set address to 5
	write_data = 8'd12; // set write data to 12
	rw_select = 0; // write
	// start with a normal write opperation
	for (i=0; i<7; i=i+1) begin
	    mosi = address[6-i];
	    @(negedge spi_clk);
	end
	mosi = rw_select;
	for (i=0; i<8; i=i+1) begin
	    @(negedge spi_clk);
	    mosi = write_data[7-i];
	end

	// toggle chip select
	@(negedge spi_clk);
	chip_select = 1;
	@(negedge spi_clk);
	chip_select = 0;
	
	// read back data
	address = 7'd5; // set address to 5
	rw_select = 1; // read
	for (i=0; i<7; i=i+1) begin
	    mosi = address[6-i];
	    @(negedge spi_clk);
	end
	mosi = rw_select;
	@(negedge spi_clk);
	for (i=0; i<8; i=i+1) begin
	    @(posedge spi_clk);
	    read_data[7-i]=miso;
	end
	
	if (read_data != 8'd155) begin
	    $display("Test3: write to original addrss with chip disabled FAILED");
	    $display("data returned is: %d", read_data);
	    $display("original data has changed");
	    success = 0;
	end

	if (success==1) begin
	    $display("All Tests Passed!");
	end
    end
	
endmodule
