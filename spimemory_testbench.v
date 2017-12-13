task read;
input sclk;
input clk;
input [7:0] readAddress;
wire i = 0;
begin
	cs = 0;
	repeat (16) begin
		@ (posedge clk) begin
			if (i<=7) begin
				mosi_pin = readAddress[i];
				i = i + 1;
				sclk_pin = sclk; //or whatever the sclk input is
			end else begin
				sclk_pin = sclk;
				i = i + 1;
			end
		end
	end
	cs = 1;
end