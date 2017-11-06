`define WAIT 3'd0
`define READADDRESS 3'd1
`define WRITE 3'd3
`define READ 3'd4
`define READORWRITE 3'd2


module fsm 
(
    output reg MISObuff,
    output reg memWE,
    output reg addrWE,
    output reg srWE,
	
    //input posclkedge,
    input spi_clk,
    input spi_falling,
    input cs_falling,
    input rw_select
);
    reg [3:0] count;
    reg [2:0] state;
	
    initial count = 4'd0;
    initial state = `WAIT;
    initial MISObuff = 0;
    initial memWE = 0;
    initial addrWE = 0;
    initial srWE = 0;

    always @(posedge cs_falling) begin
	state <= `READADDRESS;
    end
    //always @(posedge cs) begin
//	state <= `WAIT;
  //  end

    always @(posedge spi_clk) begin
        case (state)
            `WAIT: begin
                MISObuff <= 0;
		memWE <= 0;
		addrWE <= 0;
		srWE <= 0;
            end

            `READADDRESS: begin
                if (count == 4'd6) begin
                    state <= `READORWRITE;
                    addrWE <= 1;
                    count <= 0;
		    @(posedge spi_falling) begin
			addrWE <= 0;
		    end
                end
                else
                    count = count + 1;
		
            end

            `READORWRITE: begin
                if (rw_select == 0) begin
                    state <= `WRITE;
                end
		else begin
		    srWE <= 1;
		    MISObuff <= 1;
		    state <= `READ;
		    @(posedge spi_falling) begin
			srWE <= 0;
		    end
		end
            end

            `WRITE: begin
                if (count == 4'd7) begin
                    count <= 0;
                    memWE <= 1;
                    state <= `WAIT;
		    @(posedge spi_falling) begin
			memWE <= 0;
		    end
                end
                else
                    count <= count + 1;

            end

            `READ: begin
		srWE <= 0;
                if (count == 4'd7) begin
                    count <= 0;
                    state <= `WAIT;
                end
                else
                    count <= count + 1;
            end

            default:  begin end
        endcase
    end
/*
    always @(posedge negclkedge) begin
        case (state)
            `READORWRITE: begin
                if (wr_enable == 1) begin
                    state <= `READ;
                    q3 <= 1;
                    buffer <=1;
                end
            end
            default: begin end
        endcase
    end
*/

endmodule
