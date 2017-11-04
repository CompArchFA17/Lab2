// Test Bench for full SPI memory

`include "spimemory.v"

module testSPImem();

    // inputs and outputs for function
    reg clk;
    reg spi_clk;
    reg chip_select = 1;
    wire miso = 0;
    reg mosi = 0;
    wire[3:0] leds;

    // registers for testing
    reg[6:0] address;
    reg rw_select;
    reg[7:0] write_data;
    reg[7:0] read_data;
    wire[7:0] cmd = {address, rw_select};
    reg[3:0] i;

    spiMemory test(clk, spi_clk, chip_select, miso, mosi, leds);

    // generate clock
    initial clk = 0;
    always #5 clk = !clk; //100 MHz clock

    initial spi_clk = 0;
    always #20 spi_clk = !spi_clk; //25 MHz clock

    initial
        #10000 $finish;

    initial begin
	$dumpfile("spimemory.vcd");
	$dumpvars();
	$display("testing SPI memory");
	$display("TEST 1: write to address 5 and read back");
	// initialize values to write
	address = 7'd5; // set address to 5
	write_data = 8'd155; // set write data to 155
	rw_select = 0; // write first
	#100; // wait at the beginning for fun
	// start with a normal write opperation
	chip_select = 0; // select chip
	for (i=0; i<7; i=i+1) begin
	    @(posedge spi_clk);
	    mosi = address[i];
	end
	@(posedge spi_clk);
	mosi = rw_select;
	for (i=0; i<8; i=i+1) begin
	    @(posedge spi_clk);
	    mosi = write_data[i];
	end

	// toggle chip select
	chip_select = 1;
	#40;
	chip_select = 0;

	// read back data
	address = 7'd5; // set address to 5
	rw_select = 1; // read
	// start with a normal write opperation
	for (i=0; i<7; i=i+1) begin
	    @(posedge spi_clk);
	    mosi = address[i];
	end
	@(posedge spi_clk);
	mosi = rw_select;
	for (i=0; i<8; i=i+1) begin
	    @(posedge spi_clk);
	    read_data[i]=miso;
	end
	$display("data returned is: %b", read_data);
	
	$display("TEST 2: write to a second address and read values from both");
	// toggle chip select
	chip_select = 1;
	#40;
	chip_select = 0;

	// initialize values to write
	address = 7'd120; // set address to 120
	write_data = 8'd3; // set write data to 3
	rw_select = 0; // write first
	// start with a normal write opperation
	for (i=0; i<7; i=i+1) begin
	    @(posedge spi_clk);
	    mosi = address[i];
	end
	@(posedge spi_clk);
	mosi = rw_select;
	for (i=0; i<8; i=i+1) begin
	    @(posedge spi_clk);
	    mosi = write_data[i];
	end

	// toggle chip select
	chip_select = 1;
	#40;
	chip_select = 0;
	
	// read back data
	address = 7'd5; // set address to 5
	rw_select = 1; // read
	// start with a normal write opperation
	for (i=0; i<7; i=i+1) begin
	    @(posedge spi_clk);
	    mosi = address[i];
	end
	@(posedge spi_clk);
	mosi = rw_select;
	for (i=0; i<8; i=i+1) begin
	    @(posedge spi_clk);
	    read_data[i]=miso;
	end
	$display("data returned from first address: %b", read_data);
	
	// toggle chip select
	chip_select = 1;
	#40;
	chip_select = 0;
	
	// read back data
	address = 7'd120; // set address to 120
	rw_select = 1; // read
	// start with a normal write opperation
	for (i=0; i<7; i=i+1) begin
	    @(posedge spi_clk);
	    mosi = address[i];
	end
	@(posedge spi_clk);
	mosi = rw_select;
	for (i=0; i<8; i=i+1) begin
	    @(posedge spi_clk);
	    read_data[i]=miso;
	end
	$display("data returned from second address: %b", read_data);
    end
	
endmodule
