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

cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #200
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #180
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #200


/* TESTING FOR CHIP SELECT 1 DOES NOTHING
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
*/

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


// TURN CHIP SELECT ON
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 1;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 1;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // THESE SET IT TO WRITE
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160 // SET TO WRITE
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 0
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160  
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 1
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 2
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 3
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 1;  #160 // 4
cs_pin = 0; sclk_pin= 0; mosi_pin = 1;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 1;  #160 // 5
cs_pin = 0; sclk_pin= 0; mosi_pin = 1;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 6
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 7
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 8
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #600 
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #600
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #600
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #600
// start counting address again - FOR READING
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 1;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 1;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 1;  #160 // SET TO READ
cs_pin = 0; sclk_pin= 0; mosi_pin = 1;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 0
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 1
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 2
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 3
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 1;  #160 // 4
cs_pin = 0; sclk_pin= 0; mosi_pin = 1;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 1;  #160 // 5
cs_pin = 0; sclk_pin= 0; mosi_pin = 1;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 6
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 7
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 0; sclk_pin= 1; mosi_pin = 0;  #160 // 8
cs_pin = 0; sclk_pin= 0; mosi_pin = 0;  #160
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #600 
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #600
cs_pin = 1; sclk_pin= 0; mosi_pin = 0;  #600
cs_pin = 1; sclk_pin= 1; mosi_pin = 0;  #600



$finish;
end

endmodule 
