//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`define READ_ADDRESS 2'd0
`define READ_WR      2'd1
`define WRITE_DATA   2'd2
`define READ_DATA    2'd3
`include "shiftregister.v"
`include "inputconditioner.v"
`include "datamemory.v"

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output reg      miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);
wire mosi;
wire cs;
wire sclk_neg;
wire sclk_pos;
wire[7:0] shift_pOut;
wire      shift_sOut;
wire[7:0] mem_out;
reg[6:0] addressReg;
reg[2:0] state;
reg[4:0] bitsTx;
reg load_shift;
reg load_mem;

inputconditioner mosicond(.clk(clk), .noisysignal(mosi_pin), .conditioned(mosi));
inputconditioner cscond(  .clk(clk), .noisysignal(cs_pin),   .conditioned(cs));
inputconditioner sclkcond(.clk(clk), .noisysignal(sclk_pin),
                          .positiveedge(sclk_pos), .negativeedge(sclk_neg));

shiftregister shiftReg(.clk(clk), .peripheralClkEdge(sclk_pos),
                       .parallelDataOut(shift_pOut), .serialDataOut(shift_sOut),
                       .serialDataIn(mosi), .parallelLoad(load_shift), .parallelDataIn(mem_out)
                       );
datamemory mem(.clk(clk),
               .dataOut(mem_out),
               .address(addressReg),
               .writeEnable(load_mem),
               .dataIn(shift_pOut));

initial begin
   state      <= `READ_ADDRESS;
   addressReg <= 7'd0;
   bitsTx     <= 4'd0;
   load_shift <= 0;
   load_mem   <= 0;
   miso_pin <= 'z;
end

always @(negedge sclk_pos) begin
  if(!cs) begin
    if(state == `READ_ADDRESS) begin
      bitsTx <= bitsTx + 1;
      if(bitsTx == 7) begin
        state   <= `READ_WR;
        addressReg <= shift_pOut[6:0];
      end
    end
    if(state == `READ_DATA) begin
      bitsTx = bitsTx + 1;
      if(bitsTx == 8) begin
        load_mem <= 1;
      end
    end
    if(state == `READ_WR) begin
      if(shift_pOut[0] == 0) begin
        state <= `READ_DATA;
      end
      if(shift_pOut[0] == 1) begin
        state <= `WRITE_DATA;
        load_shift <= 1;
      end
      bitsTx <= 4'd0;
    end
  end
end

always @ (posedge sclk_neg) begin
  if(load_mem) begin
    load_mem <= 0;
  end
  if(load_shift) begin
    load_shift <= 0;
  end
  if(!cs) begin
    if(state == `WRITE_DATA) begin
      miso_pin <= shift_sOut;
      bitsTx <= bitsTx + 1;
    end
  end
end

always @(posedge cs) begin
  state    <= `READ_ADDRESS;
  bitsTx   <= 4'd0;
  miso_pin <= 'z;
  load_mem <= 0;
  load_shift <= 0;
end

endmodule
