//----------------------------------------------------------------------
// SPI Memory test bench
//----------------------------------------------------------------------
`include "spimemory.v"

module testMemory();

   reg clk;
   reg sclk_pin;
   reg cs_pin;
   reg mosi_pin;
   wire miso_pin;
   reg [6:0] address;
   reg [7:0] data;
   reg 	dutpassed;
   reg[31:0] i;
   
   spiMemory dut(.clk(clk), 
		 .sclk_pin(sclk_pin), 
		 .cs_pin(cs_pin),
		 .mosi_pin(mosi_pin), 
		 .miso_pin(miso_pin));

   initial begin
      clk = 0;
      sclk_pin = 0;
      cs_pin = 0;
      mosi_pin = 0;
   end
   //always #10 clk != clk;

   initial begin
   address = 7'b1010101;
   data = 8'b11110000;
   
   //write address
   for(i=0; i < 7; i=i+1) begin
      mosi_pin = address[i];
      sclk_pin = 1;
      #100;
      sclk_pin = 0;
   end
   
   //set write
   mosi_pin = 0;
   sclk_pin = 1;
   #100;
   sclk_pin = 0;
   
   //write data
   for(i=0; i < 8; i=i+1) begin
      mosi_pin = data[i];
      sclk_pin = 1;
      #100;
      sclk_pin = 0;
   end

   //write address
   for(i=0; i < 7; i=i+1) begin
      mosi_pin = address[i];
      sclk_pin = 1;
      #100;
      sclk_pin = 0;
   end

   //set read
   mosi_pin = 0;
   sclk_pin = 1;
   #100;
   sclk_pin = 0;

   //read data
   for(i=0; i < 8; i=i+1) begin
      if(miso_pin != data[i]) begin
	 $display("read byte is different from written byte");
	 dutpassed = 0;
      end
      sclk_pin = 1;
      #100;
      sclk_pin = 0;
   end


   if(dutpassed) begin
      $display("DUT passed");
    end
    else begin
      $display("DUT failed");
    end

   end
endmodule
