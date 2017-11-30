//Finite state machine test bench
`timescale 1 ns / 1 ps
`include "fsm.v"
module testFSM();

    reg lsb;
    reg chipSelect;
    reg clk;
    wire sr_we;
    wire addr_we;
    wire dm_we;
    wire[4:0] currentState;

    fsm dut(lsb, chipSelect, clk, sr_we, addr_we, dm_we, currentState); 
    initial clk=0;
    always #10 clk=!clk;

    initial begin
        $dumpfile("fsm.vcd");
        $dumpvars(0, testFSM);    
        lsb=1;chipSelect=1; #350
        $display("testing chip select");
        chipSelect=0; #10
        
        lsb=0;chipSelect=1;
    end
endmodule 
