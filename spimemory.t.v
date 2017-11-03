//------------------------------------------------------------------------
// SPI Memory test bench
//------------------------------------------------------------------------
`timescale 1 ns / 1 ps
`include "spimemory.v"

module testspimemory();

	reg clk;
	reg cs;
	reg sclk;
	reg mosi;	
	output miso;
	reg[7:0] data; // For test

	spiMemory spi(.clk(clk), .sclk_pin(sclk), .cs_pin(cs), .miso_pin(miso), .mosi_pin(mosi));


    // Generate clock (50MHz)
    initial clk=0;
    initial sclk = 0;
    always #10 clk=!clk;    // 50MHz Clock
    always #100 sclk=!sclk;  // 10 Clock period

    initial begin
    $dumpfile("spimemory.vcd");
    $dumpvars(0,testspimemory);

    $display("SPI Memory Test start");
    cs = 1; #150
    cs = 0;

    mosi=1; #1200 mosi = 0; #200 // input address: 1111110
    mosi=0; #200  //write
    mosi=1; #200 mosi=0; #200; mosi=1; #200 mosi=0; #400 mosi=1; #600 // input data: 10100111
    $display("Write '10100111' to addess '1111110'");

    cs = 1; mosi = 0; #2000
    cs = 0;

    mosi=1; #1200 mosi = 0; #200 // input address: 1111110
    mosi=1; #200 // read
    mosi=0;
    #400 data[7]=miso;#200 data[6]=miso;#200 data[5]=miso;#200 data[4]=miso;
    #200 data[3]=miso;#200 data[2]=miso;#200 data[1]=miso;#200 data[0]=miso;// read data
    $display("Input address  |  Output Data  |  Expected Result");
    $display("1111110        |  %b     |  10100111", data);

    cs = 1; mosi = 0; #2000
    cs = 0;

    mosi=1; #400 mosi=0; #600 mosi=1; #200 mosi=0; #200 // input address: 1100010
    mosi=0; #200 //write
    mosi=0; #200 mosi=1; #200 mosi=0; #800 mosi=1; #400 // input data: 01000011
    $display("Write '01000011' to addess '1100010'");

    cs = 1; mosi = 0; #2000
    cs = 0;

    mosi=1; #1200 mosi = 0; #200  // input address: 1111110
    mosi=1; #200 // read
    mosi=0;
    #400 data[7]=miso;#200 data[6]=miso;#200 data[5]=miso;#200 data[4]=miso;
    #200 data[3]=miso;#200 data[2]=miso;#200 data[1]=miso;#200 data[0]=miso;// read data
    $display("1111110        |  %b     |  10100111", data);

    cs = 1; mosi = 0; #2000
    cs = 0;

	mosi=1; #400 mosi=0; #600 mosi=1; #200 mosi=0; #200 // input address: 1100010
    mosi=1; #200 // read
    mosi=0;
    #400 data[7]=miso;#200 data[6]=miso;#200 data[5]=miso;#200 data[4]=miso;
    #200 data[3]=miso;#200 data[2]=miso;#200 data[1]=miso;#200 data[0]=miso;// read data
    $display("1100010        |  %b     |  01000011", data);

    cs = 1; mosi = 0; #2000
    cs = 0;

	mosi=1; #1400 // input address: 1111111
    mosi=1; #200 // read
    mosi=0;
    #200 data[7]=miso;#200 data[6]=miso;#200 data[5]=miso;#200 data[4]=miso;
    #200 data[3]=miso;#200 data[2]=miso;#200 data[1]=miso;#200 data[0]=miso;// read data
    $display("1111111        |  %b     |  xxxxxxxx", data);

    cs = 1;
    $display("End test");

    end

endmodule