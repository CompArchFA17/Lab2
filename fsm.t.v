`timescale 1ns / 1ps

`include "fsm.v"

module fsm_test ();
	reg sclk, chip_sel, shift_reg_out;
	wire miso_buff, dm_we, addr_we, sr_we;

	fsm dut (.sclk(sclk), .chip_sel(chip_sel), .shift_reg_out(shift_reg_out),
		.miso_buff(miso_buff), .dm_we(dm_we), .addr_we(addr_we), .sr_we(sr_we));


		always begin
        	#5 sclk = ~sclk;
  	  	end

	initial begin
		$dumpfile("fsm.vcd");
		$dumpvars();

		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// chip_sel = 1; shift_reg_out = 1; #10
		// $displayb("miso_buff: %b", miso_buff);
		// $displayb("dm_we: %b", dm_we);
		// $displayb("addr_we: %b", addr_we);
		// $displayb("sr_we: %b", sr_we);

		// chip_sel = 0;
		// shift_reg_out = 0; #70
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// shift_reg_out = 0; #10
		// sclk = 1; #5
		// sclk = 0; #5

		// shift_reg_out = 0; #80
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5

		// chip_sel = 1; #5



		sclk = 0;
		chip_sel = 0;
		shift_reg_out = 0; #80
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0;

		shift_reg_out = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5
		// sclk = 1; #5
		// sclk = 0; #5

		$displayb("miso_buff: %b", miso_buff);
		$displayb("dm_we: %b", dm_we);
		$displayb("addr_we: %b", addr_we);
		$displayb("sr_we: %b", sr_we);

		$finish();
	end

endmodule