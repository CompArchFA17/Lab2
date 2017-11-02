`timescale 1 ns / 1 ps
`include "spimemory.v"

module spiTest();
  reg clk;
  reg sclk_pin;
  reg cs_pin;
  wire miso_pin;
  reg mosi_pin;
  wire [3:0] leds;
  wire [7:0]q0;
  wire q1;
  wire q2;
  
  integer counter; // used in for loops
  
  initial clk=0;
  always #10 clk= !clk;    // 50MHz Clock

  
  spiMemory dut(clk, sclk_pin, cs_pin, miso_pin, mosi_pin, leds, q0[7:0], q1, q2);
  initial begin
    $dumpfile("spimemory.vcd");
    $dumpvars(0, clk, sclk_pin, cs_pin, miso_pin, mosi_pin, q0[7:0], q1, q2);
    
    // initial output
    cs_pin <= 1;
    mosi_pin <= 0;
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000
    
    $display("sclk_pin | cs_pin | mosi_pin | miso_pin |");
    $display("   %b     | %b      | %b        |   %b     |%b|%b|%b", sclk_pin, cs_pin, mosi_pin, miso_pin, q0[7:0], q1, q2);
    
    // write operation
    
    // give address 0 and write bits
    cs_pin = 0;#1000;
    for (counter = 0; counter < 16; counter = counter + 1) begin 
      if (counter > 7) begin //write 1's to address
        mosi_pin <= 1;
      end
      else begin
        mosi_pin <= 0;
      end
      if (counter == 12) begin
        mosi_pin <= 0;
      end
      if (counter == 13) begin
        mosi_pin <= 1;
      end
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000;
      $display("   %b     | %b      | %b        |   %b     |%b|%b|%b", sclk_pin, cs_pin, mosi_pin, miso_pin, q0[7:0], q1, q2);
    end
    $display("Wrote 11111111 to address 0");
		$display("   %b     | %b      | %b        |   %b     |%b|%b|%b", sclk_pin, cs_pin, mosi_pin, miso_pin, q0[7:0], q1, q2);
    cs_pin <= 1;
    mosi_pin <= 0;
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000000
    //
    
    
    
    
    //read operation
    cs_pin <= 0;#1000;
    $display("Reading address");
    for (counter = 0; counter < 8; counter = counter + 1) begin 
      if (counter == 0) begin //resetting mosi_pin to read from address 
        mosi_pin <= 0;
      end
      else if(counter==7) begin
        mosi_pin<=1;
      end
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000;
      $display("   %b     | %b      | %b        |   %b     |%b|%b|%b", sclk_pin, cs_pin, mosi_pin, miso_pin, q0[7:0], q1, q2);
    end
    // now output the bits that were read from address 1
    $display("Reading data at address 0");
    for (counter = 0; counter < 8; counter = counter + 1) begin
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000
      $display("   %b     | %b      | %b        |   %b     |%b|%b|%b", sclk_pin, cs_pin, mosi_pin, miso_pin, q0[7:0], q1, q2);
    end
    cs_pin <= 1;
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000

    
    // write operation in same address
    
    //read operation
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000

    #1000000 
    $finish;
   
  end
endmodule