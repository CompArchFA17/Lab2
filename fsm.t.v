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

    fsm dut(lsb, chipSelect, clk, sr_we, addr_we, dm_we); 
    initial clk=0;
    always #10 clk=!clk;

    initial begin
        $dumpfile("fsm.vcd");
        $dumpvars(0, testFSM);    
        lsb=0;chipSelect=1;
        $display("testing chip select");
    end
endmodule 
