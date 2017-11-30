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

    $display("clk  noisysignal  | conditioned  posedge  negedge | expected output");  
    // initial condition
    pin=0; #5 //Offsetting signal
    pin=1; #100

    // test input synchronization
    pin=0; #100
    
    // test debouncing & edge detection
    pin=0; #100
    pin=1; #20
    pin=0; #30
    pin=1; #150

    pin=0; #10
    pin=1; #20
    pin=0; #100
    
    // test maximum glitch
    pin=1; #50
    pin=0; #30
    pin=1; #60
    pin=0; #30
    pin=1; #70
    pin=0; #30
    pin=1; #80
    pin=0; #30
    pin=1; #150
    pin=0;

    //Take a look at sync.png file for the waveform and confirm the proper behaviors

    
    end    
endmodule
