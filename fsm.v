`timescale 1 ns / 1 ps

//Example of a Finite State Machine where the traffic light state dictates the driving.

module finiteStateMachine(
    input [2:0],
    input clk,
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

    if (addressLoad == ) begin 
        if (counter == 8) begin
            counter = 0;
        end
        else begin
            counter = counter + 1;
        end
    end

    
    case (state)
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