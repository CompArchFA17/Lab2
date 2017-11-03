// ideas for code
// same counter for each one --> just reset back to zero
// if chip select high (use always statement) --> 



module fsm
(
	input sclk,
	input chip_sel,
	input shift_reg_out,
	output reg miso_buff,
	output reg dm_we,
	output reg addr_we,
	output reg sr_we
);

	reg [3:0] count;
	reg [7:0] outputval;
	reg rw;

	// State encoding (one hot)
	reg [5:0] state;
	localparam STATE_START = 6'b000001, STATE_RECIEVE = 6'b000010,
		STATE_WRITE = 6'b000100, STATE_READ0 = 6'b001000,
		STATE_READ1 = 6'b010000, STATE_END = 6'b100000;

	// State logic
	always @(posedge sclk) begin
	// always @(sclk) begin
		if (state === 6'bx) begin
			state <= STATE_START;
		end

		else begin

			case(state)

				STATE_START: begin
					if (chip_sel == 1) begin
						state <= STATE_START;
					end
					else if (chip_sel == 0) begin
						state <= STATE_RECIEVE;
						count <= 4'd0;
					end
				end

				STATE_RECIEVE: begin
					if (count < 4'd7) begin
						count <= count + 4'd1;
					end
					else if (count == 4'd7) begin
						// rw <= shift_reg_out;
						if (shift_reg_out === 1'b1) begin
							state <= STATE_READ0;
							count <= 4'd0;
						end
						else if (shift_reg_out === 1'b0) begin
							state <= STATE_WRITE;
							count <= 4'd0;
						end
						else if (shift_reg_out === 1'bx) begin
							count <= count;
						end
					end
				end

				STATE_WRITE: begin
					if (count < 4'd7) begin
						count <= count + 4'd1;
					end
					else if (count == 4'd7) begin
						state <= STATE_END;
						count <= 4'b0;
					end
				end

				STATE_READ0: begin
					state <= STATE_READ1;
				end

				STATE_READ1: begin
					if (count < 4'd7) begin
						count <= count + 4'd1;
					end
					else if (count == 4'd7) begin
						state <= STATE_END;
						count <= 4'b0;
					end
				end

				STATE_END: begin
					if (chip_sel == 1) begin
						state <= STATE_START;
					end
				end

			endcase
		end
	end


	// Output logic
	always @(state) begin

		case (state)

			STATE_START: begin
				addr_we <= 1'b0;
				dm_we <= 1'b0;
				miso_buff <= 1'b0;
				sr_we <= 1'b0;
			end

			STATE_RECIEVE: begin
				addr_we <= 1'b1;
				dm_we <= 1'b0;
				miso_buff = 1'b0;
				sr_we = 1'b0;
			end

			STATE_WRITE: begin
				addr_we <= 1'b0;
				dm_we <= 1'b1;
				miso_buff <= 1'b0;
				sr_we <= 1'b0;
			end

			STATE_READ0: begin
				addr_we <= 1'b0;
				dm_we <= 1'b0;
				miso_buff <= 1'b0;
				sr_we <= 1'b1;
			end

			STATE_READ1: begin
				addr_we <= 1'b0;
				dm_we <= 1'b0;
				miso_buff <= 1'b1;
				sr_we <= 1'b0;
			end

			STATE_END: begin
				addr_we <= 1'b0;
				dm_we <= 1'b0;
				miso_buff <= 1'b0;
				sr_we <= 1'b0;
			end

		endcase

	end

endmodule