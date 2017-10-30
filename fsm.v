`timescale 1 ns / 1 ps

//Example of a Finite State Machine where the traffic light state dictates the driving.

module finiteStateMachine(
    input sclk_pos,
    input chip_select,
    input r_w,
    output reg MISO_BUFE,
    output reg DM_WE,
    output reg ADDR_WE,
    output reg SR_WE
);


reg [7:0] state;
localparam addressLoad;
localparam branch;
localparam write;
localparam read;
localparam reset;
//localparam CSHigh = 2'b00;

integer counter = 0;
//change states on the clk cycles
always @(posedge clk) begin

    // commands: CS_Low, done address load, parallelDataLoad, serialDataLoad
    // CS_high

    reg [7:0] prev_state = state;
    if (chip_select == 0) begin
        state <= addressLoad;
    end
    else if (prev_state == addressLoad) begin
        if (counter == 8) begin 
            counter = 0;
            state <= branch;
        end
        else begin
            counter = counter + 1;
        end
    end
    else if (state == branch) begin
        if (r_w == 0) begin // write
            state <= write;
        end 
        else begin // read
            state <= read;
        end 
    end
    else if (state == write || state == write) begin
        if (counter == 8) begin 
            counter = 0;
            state <= reset;
        end
        else begin
            counter = counter + 1;
        end
    end

    else if (state <= reset) begin
        state <= reset;
    end
    


    case (state)
        addressLoad: begin
            MISO_BUFE = 0;
            DM_WE = 0;
            ADDR_WE = 1;
            SR_WE = 0;
        end
        branch: begin
            MISO_BUFE = 0;
            DM_WE = 0;
            ADDR_WE = 0;
            SR_WE = 0;
        end
        write: begin
            MISO_BUFE = 0;
            DM_WE = 1;
            ADDR_WE = 0;
            SR_WE = 0;
        end
        read: begin
            MISO_BUFE = 1;
            DM_WE = 0;
            ADDR_WE = 0;
            SR_WE = 1;
        end

        reset: begin
            MISO_BUFE = 0;
            DM_WE = 0;
            ADDR_WE = 0;
            SR_WE = 0;
        end
    endcase
end
endmodule
