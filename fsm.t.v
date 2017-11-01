`timescale 1 ns / 1 ps
`include "fsm.v"

module fsmTest();
  reg shiftRegOut = 1;
  reg CS = 1;
  reg sclk = 0;
  reg clk;
  
  wire MISOBUFE;
  wire DM_WE;
  wire ADDR_WE;
  wire SR_WE;

  integer counter;
  
  fsm f(shiftRegOut, CS, sclk, clk, MISOBUFE, DM_WE, ADDR_WE, SR_WE);
  // Generate clock (50MHz)
  initial clk=0;
  always #10 clk=!clk;    // 50MHz Clock


  initial begin
  $dumpfile("fsm.vcd");

  $display("shiftRegOut | sclk | MISOBUFE | DM_WE | ADDR_WE | SR_WE ");
  
  // check to make sure all outputs are still 0 while CS is high
        CS = 1;
    sclk = 0; #10
    sclk = 1; #10
    $display("%b        | %b   | %b       | %b     | %b       | %b", shiftRegOut, sclk, MISOBUFE, DM_WE, ADDR_WE, SR_WE);
    sclk = 0; #10
    sclk = 1; #10
    $display("%b        | %b   | %b       | %b     | %b       | %b", shiftRegOut, sclk, MISOBUFE, DM_WE, ADDR_WE, SR_WE);
  
  // Make sure outputs change when CS goes low
    // test for read
    CS = 0; shiftRegOut = 1;
      
    for (counter = 0; counter < 17; counter = counter + 1)
          begin 
        sclk = 0; #10
            sclk = 1; #10
        $display(" %b        | %b   | %b       | %b     | %b       | %b", shiftRegOut, sclk, MISOBUFE, DM_WE, ADDR_WE, SR_WE);
      end
    
    // test for write
    $display("Testing for write");
    CS = 1; #50
    sclk = 0; #10
    sclk = 1; #10
    CS = 0; shiftRegOut = 0; #10
    
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    $display(" %b        | %b   | %b       | %b     | %b       | %b", shiftRegOut, sclk, MISOBUFE, DM_WE, ADDR_WE, SR_WE);
    
    sclk = 0; #10
    sclk = 1; #10
    $display(" %b        | %b   | %b       | %b     | %b       | %b", shiftRegOut, sclk, MISOBUFE, DM_WE, ADDR_WE, SR_WE);
    
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    sclk = 0; #10
    sclk = 1; #10
    $display(" %b        | %b   | %b       | %b     | %b       | %b", shiftRegOut, sclk, MISOBUFE, DM_WE, ADDR_WE, SR_WE);
    
    sclk = 0; #10
    sclk = 1; #10
    $display(" %b        | %b   | %b       | %b     | %b       | %b", shiftRegOut, sclk, MISOBUFE, DM_WE, ADDR_WE, SR_WE);


  #10000 
    $finish;
end
endmodule