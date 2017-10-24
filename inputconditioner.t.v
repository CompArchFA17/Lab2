
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
    always #10 clk = !clk;    // 50MHz Clock

    initial begin
        // Input Debouncing Tests
        // Test Case 1: Noisy high input signal
        pin = 0; #300
        pin = 1; #5
        pin = 0; #5
        pin = 1; #5
        pin = 0; #5
        pin = 1; #5
        pin = 0; #5
        pin = 1; #5
        pin = 0; #5
        pin = 1; #5
        pin = 0; #5
        pin = 1; #250

        // Expect the conditioned output to be high when the pin input has stabilized.
        if (conditioned != 1) begin
            $display("Test Case X failed. conditioned output is not high");
        end

        // Test Case 2: Noisy low input signal
        pin = 0; #5
        pin = 1; #5
        pin = 0; #5
        pin = 1; #5
        pin = 0; #5
        pin = 1; #5
        pin = 0; #5
        pin = 1; #5
        pin = 0; #5
        pin = 1; #5
        pin = 0; #250

        // Expect the conditioned output to be low when the pin input has stabilized.
        if (conditioned != 0) begin
            $display("Test Case X failed. conditioned output is not low");
        end
    end
    
    // Edge Detection Tests
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
        #5;
        if (rising != 1) begin
            $display("Test Case 3 failed: rising edge not detected at time %t", $time);
            $display("rising: %b", rising);
        end
    end
    
    // Test Case 4: Negative Edge Detection
    always @(negedge conditioned) begin
        #5;
        if (falling != 1 && $time > 100) begin
            $display("Test Case 4 failed: falling edge not detected at time %t", $time);
            $display("falling: %b", falling);
        end
    end
endmodule
