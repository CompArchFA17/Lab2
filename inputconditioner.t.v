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
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin
    $dumpfile("inputconditioner.vcd");
    $dumpvars(0,testConditioner);
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronization, Debouncing, Edge Detection

    $display("clk  noisysignal  | conditioned  posedge  negedge");  
    pin=0; #5 //Offsetting signal
    pin=1; #200
    pin=0; #200
    $display("%b    %b   | %b   %b   %b", clk, pin, conditioned, rising, falling);
    //Take a look at sync.png file for the waveform and confirm the proper behaviors

    
    end    
endmodule
