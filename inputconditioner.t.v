//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`include "inputconditioner.v"

module testConditioner();

    reg clk = 0;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    
    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));

    // Generate clock (50MHz)
    initial begin
       forever begin
          clk = !clk; #10;
       end
    end
    
    initial begin
       pin = 0; #50;
       pin = 1; #100;
       pin = 0; #100;
       pin = 1; #150;
       pin = 0; #30;
       pin = 1; #60;
       pin = 0; #30;
    end
    
endmodule
