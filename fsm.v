`timescale 1 ns / 1 ps

//Example of a Finite State Machine where the traffic light state dictates the driving.

module finiteStateMachine(
    input [1:0],
    input clk,
    output reg MISO_BUFE,
    output reg DM_WE,
    output reg ADDR_WE,
    output reg SR_WE
);
    

reg [1:0] state;
localparam Green = 2'b00;
localparam Yellow = 2'b01;
localparam Red = 2'b10;

//change states on the clk cycles
always @(posedge clk) begin

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

    case (state)
        //driving - follow traffic laws
        Green: begin
            driving = 1;
            braking = 0;
            stopped <= 0;
        end
        Yellow: begin
            driving = 0;
            braking = 1;
            stopped <= 0;
        end
        Red: begin
            driving = 0;
            braking = 0;
            stopped <= 1;
        end
    endcase
end
endmodule