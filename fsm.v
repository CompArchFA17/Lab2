//Finite state machine
module fsm
(
input lsb,  //Least significant bit
input chipSelect, //Chip select
input clk,  //Serial clock
output reg sr_we,
output reg addr_we,
output reg dm_we
);
    parameter beg = 0;
    parameter loadA6 = 1;

    reg currentState = beg;
    always @(posedge clk) begin
        if (chipSelect && currentState == beg) begin
            currentState = loadA6;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (chipSelect && currentState == loadA6) begin
            currentState = loadRW;
            sr_we <= 0;
            addr_we <= 1;
            dm_we <= 0;
        end
    end
endmodule
