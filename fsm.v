//Finite state machine
module fsm
(
input lsb,  //Least significant bit
input chipSelect, //Chip select
input clk,  //Serial clock
output reg sr_we,
output reg addr_we,
output reg dm_we,
output reg[4:0] currentState
);
    parameter beg = 0;
    parameter loadA6 = 1;
    parameter loadA5 = 2;
    parameter loadA4 = 3;
    parameter loadA3 = 4;
    parameter loadA2 = 5;
    parameter loadA1 = 6;
    parameter loadA0 = 7;
    parameter loadRW = 8;

    parameter readD7 = 9;
    parameter readD6 = 10;
    parameter readD5 = 11;
    parameter readD4 = 12;
    parameter readD3 = 13;
    parameter readD2 = 14;
    parameter readD1 = 15;
    parameter readD0 = 16;

    parameter writeD7 = 17;
    parameter writeD6 = 18;
    parameter writeD5 = 19;
    parameter writeD4 = 20;
    parameter writeD3 = 21;
    parameter writeD2 = 22;
    parameter writeD1 = 23;
    parameter writeD0 = 24;

    initial currentState = beg;
    always @(posedge clk) begin
        if (!chipSelect && currentState == beg) begin
            currentState <= loadA6;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == loadA6) begin
            currentState <= loadA5;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == loadA5) begin
            currentState <= loadA4;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == loadA4) begin
            currentState <= loadA3;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == loadA3) begin
            currentState <= loadA2;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == loadA2) begin
            currentState <= loadA1;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == loadA1) begin
            currentState <= loadA0;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == loadA0) begin
            currentState <= loadRW;
            sr_we <= 0;
            addr_we <= 1;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == loadRW) begin
            if (lsb == 1) begin
                currentState <= readD7;
                sr_we <= 1;
                addr_we <= 0;
                dm_we <= 0;
            end
            else begin
                currentState <= writeD7;
                sr_we <= 0;
                addr_we <= 0;
                dm_we <= 0;
            end
        end
        else if (!chipSelect && currentState == readD7) begin
            currentState <= readD6;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == readD6) begin
            currentState <= readD5;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == readD5) begin
            currentState <= readD4;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == readD4) begin
            currentState <= readD3;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == readD3) begin
            currentState <= readD2;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == readD2) begin
            currentState <= readD1;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == readD1) begin
            currentState <= readD0;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == writeD7) begin
            currentState <= writeD6;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == writeD6) begin
            currentState <= writeD5;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == writeD5) begin
            currentState <= writeD4;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == writeD4) begin
            currentState <= writeD3;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == writeD3) begin
            currentState <= writeD2;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == writeD2) begin
            currentState <= writeD1;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0;
        end
        else if (!chipSelect && currentState == writeD1) begin
            currentState <= writeD0;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 1;
        end
        else begin
            //Reset to begin state
            currentState <= beg;
            sr_we <= 0;
            addr_we <= 0;
            dm_we <= 0; 
        end
    end
endmodule
