//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`timescale 1 ns / 1 ps
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
    always #10 clk=!clk;  // 50MHz Clock
    initial begin
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronization, Debouncing, Edge Detection
    $dumpfile("inputconditioner.vcd");
    $dumpvars();

    //Testing Synchronization and edge detection
    pin = 0; #150
    pin = 1; #133
    pin = 0; #231
    pin = 1; #52
    pin = 0; #100

    //Testing debouncing when input bounces but remains zero
    pin = 0; #5
    pin = 1; #5
    pin = 0; #5
    pin = 1; #5
    pin = 0; #100 
    //Check that conditioned = 0 the whole time

    //Testing debouncing when input bounces and switches to one
    pin = 0; #5
    pin = 1; #5
    pin = 0; #5
    pin = 1; #2
    pin = 0; #3
    pin = 1; #1
    pin = 0; #5
    pin = 1; #160
    //Check that conditioned = 0 and then switches to 1 after pin has settled

    //Check delay for even clock cycle changes
    pin = 0; #120
    pin = 1; #120
    pin = 0; #120
    $finish;
    end
endmodule
