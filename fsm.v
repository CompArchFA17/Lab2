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

    reg[7:0] state = reset;

    integer counter = 0;
    //change states on the clk cycles

    always @(posedge clk) begin
        if (sclk_posedge) begin

            if ((state == reset) && (chip_select == 0)) begin
                state <= addressLoad;
            end
            else if (state == addressLoad) begin
                if (counter == 6) begin
                    counter <= 0;
                    state <= branch;
                end
                else begin
                    counter <= counter + 1;
                end
            end
            else if (state == branch) begin
                if (r_w == 0) begin // write
                    state <= write;
                end
                else begin // read
                    state <= dataLoad;
                end
            end
            else if (state == dataLoad) begin
                state <= read;
            end


            else if ((state == read) || (state == write)) begin
                if (counter == 7) begin
                    counter <= 0;
                    state <= reset;
                end
                else begin
                    counter <= counter + 1;
                end
            end

            else if (state <= reset) begin
                state <= reset;
            end
        end
        case (state)
            addressLoad: begin
                MISO_BUFE <= 0;
                DM_WE <= 0;
                ADDR_WE <= 1;
                SR_WE <= 0;
            end
            branch: begin
                MISO_BUFE <= 0;
                DM_WE <= 0;
                ADDR_WE <= 0;
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
                SR_WE <= 1;
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
