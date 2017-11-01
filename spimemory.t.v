//------------------------------------------------------------------------
// SPI Memory Test Bench
//------------------------------------------------------------------------
`include "spimemory.v"

module testSPIMemory();

    reg clk; // FPGA Clock
    reg sclk_pin; // SPI Clock
    reg cs_pin; // SPI Chip Select (enables SPI)
    reg mosi_pin; // SPI master out slave in
    wire miso_pin; // SPI master in slave out

    spiMemory spi(clk, sclk_pin, cs_pin, mosi_pin, miso_pin, );

    initial clk = 0;
    initial cs_pin = 1;
    reg [7:0] testOut = 8'bxxxxxxxx; // last bit is 1 for read
    always #1 clk=!clk;

    initial begin
        $dumpfile("spimemory.vcd");
        $dumpvars;

        //#50;
        // Push input
        cs_pin = 0;
        mosi_pin = 0;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 1
        mosi_pin = 0;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 2
        mosi_pin = 0;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 3
        mosi_pin = 0;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 4
        mosi_pin = 0;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 5
        mosi_pin = 0;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 6
        mosi_pin = 0;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 7
        mosi_pin = 1;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 8

        mosi_pin = 1'bx;
        // Read output
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 1
        testOut[0] = miso_pin;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 2
        testOut[1] = miso_pin;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 3
        testOut[2] = miso_pin;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 4
        testOut[3] = miso_pin;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 5
        testOut[4] = miso_pin;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 6
        testOut[5] = miso_pin;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 7
        testOut[6] = miso_pin;
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 8
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 8
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 8
        sclk_pin = 0; #10 sclk_pin = 1; #10; // 8

        cs_pin = 1;
        $display("%8b", testOut);
        $finish;
    end

endmodule
