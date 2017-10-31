//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

`timescale 1 ns / 1 ps
`include "FSM.v"
`include "inputconditioner.v"
`include "shiftregister.v"
`include "datamemory.v"

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
)

// MOSI conditioned variables
wire MOSI;
wire positiveedge0;
wire negativeedge0;

// SCLK conditioned variables
wire conditioned1;
wire SCLKEdge;
wire negativeedge1;

// Chip Select conditioned variables
wire ChipSel;
wire positiveedge2;
wire negativeedge2;

inputconditioner serialInCond(clk, mosi_pin, MOSI, positiveedge0, negativeedge0); // MOSICond is cleaned up MOSI / Serial In

inputconditioner SCLKCond(clk, sclk_pin, conditioned1, SCLKEdge, negativeedge1); // positive edge is your cleaned up SCLKEdge

inputconditioner ChipSelCond(clk, cs_pin, ChipSel, positiveedge2, negativeedge2); // conditioned2 is your cleaned up Chip Select

// need: DFF for MISO, DFF for ADDR, DataMem, FSM


shiftregister SPIShift(clk, SCLKEdge, SR_WR, dataMemOut, MOSI, shiftRegOutP, MISO); 

endmodule
   




