
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

    // Input Debouncing Tests
    // Test Case X: ___
    initial begin
        pin = 0; #300
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #300

        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #2
        pin = 1; #2
        pin = 0; #300
        $display("writing something so this compiles :P");
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
        if (rising != 1) begin
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
