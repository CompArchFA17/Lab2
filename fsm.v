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

	reg count;
	reg [7:0] outputval;
	reg rw;

	// State encoding (one hot)
	reg [4:0] state;
	localparam STATE_START = 5'b00001, STATE_RECIEVE = 5'b00010,
		STATE_WRITE = 5'b00100, STATE_READ = 5'b01000,
		STATE_END = 5'b10000;

	// State logic

	always @(sclk) begin

		case(state)

			STATE_START: begin
				if (chip_sel == 1) begin
					state <= STATE_START;
				end
				else if (chip_sel == 0) begin
					state <= STATE_RECIEVE;
					count <= 0;
				end
			end

			STATE_RECIEVE: begin
				if (count <= 8) begin
					outputval[7 - count] <= shift_reg_out;
					count <= count + 1;
					if (count == 7) begin
						rw <= shift_reg_out;
					end
				end
				else if (count == 8) begin
					if (rw == 1) begin
						state <= STATE_READ;
						count <= 0;
					end
					else if (rw == 0) begin
						state <= STATE_WRITE;
						count <= 0;
					end
				end
			end

			STATE_WRITE: begin
				if (count <= 8) begin
					count <= count + 1;
				end
				else if (count == 8) begin
					state <= STATE_END;
				end
			end

			STATE_READ: begin
				if (count <= 8) begin
					count <= count + 1;
				end
				else if (count == 8) begin
					state <= STATE_END;
				end
			end

			STATE_END: begin
				if (chip_sel == 1) begin
					state <= STATE_START;
				end
				else if (chip_sel == 0) begin
					state <= STATE_END;
				end
			end

		endcase

	end


	// Output logic
	always @(state) begin

		case (state)

			STATE_RECIEVE: begin
				addr_we <= 1'b1;
			end

			STATE_WRITE: begin
				dm_we <= 1'b1;
			end

			STATE_READ: begin
				miso_buff <= 1'b1;
				sr_we <= 1'b1;
			end

		endcase

	end

endmodule