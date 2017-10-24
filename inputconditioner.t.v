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

    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock  
    initial begin

$dumpfile("inputconditioner.vcd");
$dumpvars();

$display(" clk | pin | conditioned | -edge| + edge"); 
pin = 0; #50
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #80
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 0; #12
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #70
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 0; #90
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #8
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 0; #70
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #150
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 0; #50
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #15
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 0; #1
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #70
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 0; #50
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #5
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 0; #280
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );

// something shiesty is going on with the passing from synchronizer 1 to the conditioned signal.
// I'll try to take a look at it again before we meet. 
// See GTK wave simulation with these paramters to observe jankness with your own eyes. 
/*
pin = 0; #50
pin = 1; #160
pin = 0; #70
pin = 1; #10
pin = 0; #80

pin = 1; #60
pin = 0; #100
pin = 1; #65
pin = 0; #100
pin = 1; #70

pin = 0; #150
*/
// pin = 1; #50
// pin = 0; #15
// pin = 1; #1
// pin = 0; #70
// pin = 1; #50



$finish; 
end

endmodule
