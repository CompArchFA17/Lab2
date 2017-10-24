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
pin = 0; #400
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #100
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 0; #2
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #100
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 0; #300
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #3
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 0; #100
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );
pin = 1; #200
$display("%b | %b | %b | %b | %b", clk, pin, conditioned, rising, falling );

$finish; 
end

endmodule
