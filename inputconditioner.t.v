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
    initial clk = 0;
    always #10 clk =! clk;    // 50MHz Clock
    

    initial begin
    //Test case 1: Input Synchronization (synchronizes signal with the internal clock)
        pin = 0; #5
        if (conditioned == 0 && clk == 0)
            $display("Test Case 1a failed: pin changed outside of clock cycle %b", clk);

        pin = 1; #5
        if (conditioned == 1 && clk == 0)
            $display("Test Case 1a failed: pin changed outside of clock cycle");
    
        pin = 0; #15
        if (conditioned != 0 && clk == 1) 
            $display("Test Case 1b failed: pin not changed inside of clock cycle");
  
        pin = 1; #15
        if (conditioned != 1 && clk == 1)
            $display("Test Case 1c failed: pin not changed inside of clock cycle");
    end


    // Test case 2: Debouncing


    // Test Case 3 + 4: Edge Detection

    initial begin
        $dumpfile("input_conditioner.vcd");
        $dumpvars();

        pin = 0; #300
        pin = 1; #300
        pin = 0; #300
        pin = 1; #300
        pin = 0; #300
        pin = 1; #300
        pin = 0; #300
        $finish();
    end

    // Test Case 3: Positive Edge Detection

    always @(posedge conditioned) begin
        if (rising != 1 && $time > 100) begin
            $display("Test Case 3 failed: rising edge not detected at time %t", $time);
            $display("rising: %b", rising);
        end
    end
    
    // Test Case 4: Negative Edge Detection

    always @(negedge conditioned) begin
        if (falling != 1 && $time > 100) begin
            $display("Test Case 4 failed: falling edge not detected at time %t", $time);
            $display("falling: %b", falling);
        end
    end

endmodule
