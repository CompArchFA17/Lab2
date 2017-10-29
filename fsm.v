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
localparam CSLow = 2'b00;
localparam addressLoad = 2'b00;
localparam CSHigh = 2'b00;

integer counter = 0;
//change states on the clk cycles
always @(posedge clk) begin

    // commands: CS_Low, done address load, parallelDataLoad, serialDataLoad
    // CS_high

    //normally you'll have an input of strings that'll dictate which states you go to (like the AddressIn)
    //but here, i'll just manually set it
    //this'll normally be much more confusing and fun. which state should you be in to start? and then generally states lead to other states.
    if (trafficlight == Green) begin
        state <= Green;
    end
    if (trafficlight == Yellow) begin
        state <= Yellow;
    end
    if (trafficlight == Red) begin
        state <= Red;
    end

    if (addressLoad == ) begin
        if (counter == 8) begin
            counter = 0;
        end
        else begin
            counter = counter + 1;
        end
    end


    case (state)
        //driving - follow traffic laws
        CSLow: begin
            MISO_BUFE = 0;
            DM_WE = 0;
            ADDR_WE = 1
            SR_WE = 0;
        end
        addressLoad: begin
            MISO_BUFE = 0;
            DM_WE = 0;
            ADDR_WE = 1;
            SR_WE = 0;
        end

        CSHigh: begin
            MISO_BUFE = 0;
            DM_WE = 0;
            ADDR_WE = 0;
            SR_WE = 0;
        end
    endcase
end
endmodule
