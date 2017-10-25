//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`include "inputconditioner.v"

module testConditioner();

    reg clk;
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
    initial clk=0;
    always #5 clk=!clk;    // 50MHz Clock

    initial begin
        $dumpfile("inputconditioner.vcd");
        $dumpvars;
        // Initialize conditioner by running at 0 for 3 clock cycles
        pin=0; #40

        pin=1; #10
        pin=0; #10
        pin=1; #80
        pin=0; #100
        pin=1; #10
        pin=0; #10
        pin=1; #10
        pin=0; #50
        pin=1; #10
        pin=0; #10
        pin=1; #10
        pin=0; #10
        pin=1; #80
        pin=0;
        #100
        $finish;
    end

    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronization, Debouncing, Edge Detection

endmodule
