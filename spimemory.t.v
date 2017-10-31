`include "spimemory.v"

module spitest();
	reg           clk;        // FPGA clock
    reg           sclk_pin;   // SPI clock
    reg           cs_pin;     // SPI chip select
    wire          miso_pin;   // SPI master in slave out
    reg           mosi_pin;   // SPI master out slave in
    wire [3:0]    leds;        // LEDs for debugging

//FSM trial1(clk, SCLKEdge, ChipSelCond, shiftRegOutPZero, MISO_BUFE, DM_WE, ADDR_WE, SR_WE);
spiMemory spitime(clk, sclk_pin, cs_pin, miso_pin, mosi_pin, leds);

initial clk=0;
always #10 clk=!clk;    // 50MHz Clock  

initial begin
$dumpfile("SPI.vcd");
$dumpvars();


$display("CS_pin | sclk_pin | MOSI  | MISO 	");

cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #2000
//$display("%b      | %b        | %b     | %b  ", cs_pin, sclk_pin, mosi_pin, miso_pin);
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #1600
//$display("%b      | %b        | %b     | %b  ", cs_pin, sclk_pin, mosi_pin, miso_pin);
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #2000
//$display("%b      | %b        | %b     | %b  ", cs_pin, sclk_pin, mosi_pin, miso_pin);
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #1600cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #2000
//$display("%b      | %b        | %b     | %b  ", cs_pin, sclk_pin, mosi_pin, miso_pin);
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #1600cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #2000
//$display("%b      | %b        | %b     | %b  ", cs_pin, sclk_pin, mosi_pin, miso_pin);
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #1600

cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48




cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 1;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #48
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #48


//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
//cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160






$finish;
end

endmodule 
