`timescale 1 ns / 1 ps

//Example of a Finite State Machine where the traffic light state dictates the driving.

module finiteStateMachine(
    input clk,
    input sclk_posedge,
    input chip_select,
    input r_w,
    output reg MISO_BUFE,
    output reg DM_WE,
    output reg ADDR_WE,
    output reg SR_WE
);
    
    localparam addressLoad = 1;
    localparam branch = 2;
    localparam write = 3;
    localparam read = 4;
    localparam reset = 0;
    localparam dataLoad = 5;
    localparam dataLoad2 = 6;
    localparam writeFinish = 7;

    reg[7:0] state = reset;

    integer counter = 0;
    //change states on the clk cycles

    always @(posedge clk) begin

        // Some state transitions should happen immediately
        if ((state == reset) && (chip_select == 0)) begin
            $display("start");
            state <= addressLoad;
        end
        else if (state == branch) begin
            $display("branch");
            if (r_w == 0) begin // write
                state <= write;
            end
            else begin // read
                state <= dataLoad;
            end
        end
        else if (state == dataLoad) begin
            $display("dataLoad1");
            state <= dataLoad2;
        end
        else if (state == dataLoad2) begin
            $display("dataLoad2");
            state <= read;
        end
        else if (state == writeFinish) begin
            $display("write finish");
            state <= reset;
        end

        // Some states need to wait a given tim based on the serial clock.
        if (sclk_posedge) begin
            if (state == addressLoad) begin
                if (counter == 7) begin
                    counter <= 0;
                    state <= branch;
                end
                else begin
                    counter <= counter + 1;
                end
            end
            else if (state == read) begin
                $display("read");
                if (counter == 7) begin
                    counter <= 0;
                    state <= reset;
                end
                else begin
                    counter <= counter + 1;
                end
            end
            else if (state == write) begin
                $display("write");
                if (counter == 8) begin
                    counter <= 0;
                    state <= writeFinish;
                end
                else begin
                    counter <= counter + 1;
                end
            end
        end


        case (state)
            addressLoad: begin
                MISO_BUFE <= 0;
                DM_WE <= 0;
                ADDR_WE <= 0;
                SR_WE <= 0;
            end
            branch: begin
                MISO_BUFE <= 0;
                DM_WE <= 0;
                ADDR_WE <= 1;
                SR_WE <= 0;
            end
            write: begin
                MISO_BUFE <= 0;
                DM_WE <= 1;
                ADDR_WE <= 0;
                SR_WE <= 0;
            end
            read: begin
                MISO_BUFE <= 1;
                DM_WE <= 0;
                ADDR_WE <= 0;
                SR_WE <= 0;
            end
            dataLoad: begin
                MISO_BUFE <= 0;
                DM_WE <= 0;
                ADDR_WE <= 0;
                SR_WE <= 0;
            end
            dataLoad2: begin
                MISO_BUFE <= 0;
                DM_WE <= 0;
                ADDR_WE <= 0;
                SR_WE <= 1;
            end
            writeFinish: begin
                MISO_BUFE <= 0;
                DM_WE <= 1;
                ADDR_WE <= 0;
                SR_WE <= 0;
            end
            reset: begin
                MISO_BUFE <= 0;
                DM_WE <= 0;
                ADDR_WE <= 0;
                SR_WE <= 0;
            end
        endcase
    end
endmodule
