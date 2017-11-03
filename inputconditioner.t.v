
//------------------------------------------------------------------------
// Input Conditioner test bench
//    Test the functions of the input condidtioner
//      - Input Synchronization
//      - Input Debouncing
//      - Edge Detection   
//------------------------------------------------------------------------

`include "inputconditioner.v"


module testConditioner();

    reg  clk;
    reg  pin;
    wire conditioned;
    wire rising;
    wire falling;

    inputconditioner dut (
        .clk         (clk),
        .noisysignal (pin),
        .conditioned (conditioned),
        .positiveedge(rising),
        .negativeedge(falling)
    );


    // Generate clock (50MHz)
    initial clk = 0;
    always #10 clk = !clk;    // 50MHz Clock

    initial begin

        $dumpfile("input_conditioner.vcd");
        $dumpvars();
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



    // Test Case 2 + 3: Debouncing

        // Test Case 2: Noisy high input signal
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

        // Test Case 3: Noisy low input signal
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

    // Test Case 4 + 5: Edge Detection

        pin = 0; #300
        pin = 1; #300
        pin = 0; #300
        pin = 1; #300
        pin = 0; #300
        pin = 1; #300
        pin = 0; #300

    $finish();
end

    // Test Case 4: Positive Edge Detection

    always @(posedge conditioned) begin
        #5;
        if (rising != 1 && $time > 100) begin
            $display("Test Case 3 failed: rising edge not detected at time %t", $time);
            $display("rising: %b", rising);
        end
    end
    
    // Test Case 5: Negative Edge Detection

    always @(negedge conditioned) begin
        #5;
        if (falling != 1 && $time > 100) begin
            $display("Test Case 4 failed: falling edge not detected at time %t", $time);
            $display("falling: %b", falling);
        end
    end
endmodule
