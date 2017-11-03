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

  
  spiMemory dut(clk, sclk_pin, cs_pin, miso_pin, mosi_pin, leds[3:0]);
  initial begin
    $dumpfile("spimemory.vcd");
    $dumpvars(0, clk, sclk_pin, cs_pin, miso_pin, mosi_pin);
    
    // initial output
    cs_pin <= 1;
    mosi_pin <= 0;
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000
    

    //Test Case 1: Write 11111111 to 000000
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
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000;
    end
    $display("Wrote 11111111 to address 0");
    cs_pin <= 1;
    mosi_pin <= 0;
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000000
    //long delay to help debug
    
    
    
    
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
    end

    //to account for lag created by SR_WE
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000;



    // now output the bits that were read from address 1
    $display("Reading data at address 0");
    for (counter = 0; counter < 10; counter = counter + 1) begin
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000
      if (counter == 8) begin
        $display("reading 2 more just in case");
      end
      $display("   %b     ",miso_pin);
    end
    cs_pin <= 1;
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000



//Test Case 1: Write 10101010 to 000001
    // write operation
    
    // give address 0 and write bits
    cs_pin = 0;#1000;
    for (counter = 0; counter < 16; counter = counter + 1) begin 
      if (counter == 6) begin //write to address
        mosi_pin <= 1;
      end
      else begin
        mosi_pin <= 0;
      end
      if(counter==7) begin
      	mosi_pin<=0;
      end
      if (counter==8) begin
      	mosi_pin<=0;
      end
      if(counter==9) begin
      	mosi_pin<=1;
      end
      if (counter==10) begin
      	mosi_pin<=0;
      end
      if(counter==11) begin
      	mosi_pin<=1;
      end
      if (counter==12) begin
      	mosi_pin<=0;
      end
      if(counter==13) begin
      	mosi_pin<=1;
      end
      if (counter==14) begin
      	mosi_pin<=0;
      end
      if(counter==15) begin
      	mosi_pin<=1;
      end
      if (counter==16) begin
      	mosi_pin<=0;
      end
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000;
    end
    $display("Wrote 10101010 to address 0000001");
    cs_pin <= 1;
    mosi_pin <= 0;
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000000
    
   
    //read operation
    cs_pin <= 0;#1000;
    $display("Reading address");


    for (counter = 0; counter < 8; counter = counter + 1) begin 
      if (counter == 0) begin //resetting mosi_pin to read from address 
        mosi_pin <= 0;
      end
      else if(counter>5) begin //read from address 1
        mosi_pin<=1;
      end
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000;
    end

    //to account for lag created by SR_WE
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000;



    // now output the bits that were read from address 0000001
    $display("Reading data at address 01");
    for (counter = 0; counter < 10; counter = counter + 1) begin
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000
      if (counter == 8) begin
      	cs_pin<=1;
        $display("reading 2 more just in case");
      end
      $display("   %b     ",miso_pin); 
    end




//read operation for address 0
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
    end

    //to account for lag created by SR_WE
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000;



    // now output the bits that were read from address 1
    $display("Reading data at address 0 again");
    for (counter = 0; counter < 10; counter = counter + 1) begin
      sclk_pin <= 0; #1000
      sclk_pin <= 1; #1000
      if (counter == 8) begin
        $display("reading 2 more just in case");
      end
      $display("   %b     ",miso_pin);
    end
    cs_pin <= 1;
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000



    cs_pin <= 1;
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000
    sclk_pin <= 0; #1000
    sclk_pin <= 1; #1000

    #1000000 
    $finish;
   
  end
endmodule