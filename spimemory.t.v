`include "spimemory.v"

module testspimemory ();
	reg mosi_pin;
	reg sclk;
	reg cs;
	reg clk;
	wire miso_pin;

	spimemory dut (clk, sclk, cs, miso_pin, mosi_pin);

	initial clk = 0;
	always #10 clk = !clk;

	initial begin
		$dumpfile("spimemory.vcd");
		$dumpvars(0, testspimemory, dut.dm.memory[0], dut.dm.memory[1]);

		// One cycle to get to first state
		cs = 1;	// keep cs high until in state
		sclk = 0; #1000
		sclk = 1; #1000

		if(dut.fsm.state != 6'b000001) begin
			$displayb("Test failed: the state is expected to be start, state is actually %b at time %t", dut.fsm.state, $time);
		end

		// Start presenting address bits 7'b1010101
		cs = 0;
		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		if(dut.fsm.state != 6'b000010) begin
			$displayb("Test failed: the state is expected to be receive, state is actually %b at time %t", dut.fsm.state, $time);
		end

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		if (dut.dm.address != 7'b0000000) begin
			$display("Test failed: the address to be written to does not match the expected address.");
		end

		// Indicate write state
		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		// Start presenting data bits 8'b 10101010
		sclk = 0; mosi_pin = 1; #1000
		sclk = 1; #1000

		if(dut.fsm.state != 6'b000100) begin
			$displayb("Test failed: the state is expected to be write, state is actually %b at time %t", dut.fsm.state, $time);
		end

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 1; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 1; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 1; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		if (dut.dm.memory[0] != 8'b10101010) begin
			$display("Test case failed: the data written to the memory does not match the expected data.");
		end

		// $display("%t",$time);


		// Chip select goes high.
		sclk = 0; cs = 1; #1000
		sclk = 1; #1000

		if(dut.fsm.state != 6'b100000) begin
			$display("Test failed: the state is expected to be end, state is actually %b at time %t", dut.fsm.state, $time);
		end

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		sclk = 0; #1000
		sclk = 1; #1000

		// Chip select goes low.
		cs = 0;

		if(dut.fsm.state != 6'b000001) begin
			$display("Test failed: the state is expected to be start, state is actually %b at time %t", dut.fsm.state, $time);
		end
		
		// Start presenting address bits '7b 1010101
		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		if(dut.fsm.state != 6'b000010) begin
			$display("Test failed: the state is expected to be receive, state is actually %b at time %t", dut.fsm.state, $time);
		end

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		if (dut.dm.address != 7'b0000000) begin
			$display("Test failed: the address to be written to does not match the expected address.");
		end

		// Indicate read state
		sclk = 0; mosi_pin = 1; #1000
		sclk = 1; #1000

		if (dut.dataMemOut != dut.dm.memory[0]) begin
			$display("Test failed: the data and memory do not match");
			$display("data: %b, mem: %b", dut.dataMemOut, dut.dm.memory[0]);
		end


		// Cycle through to push all data to serialOut
		sclk = 0; #1000
		sclk = 1; #1000
		if (miso_pin != dut.dm.memory[0][0]) begin
			$display("Test failed at time %t: output of shift register does not match the value of the memory at the correspondong address. miso_pin: %b, memory: %b", $time, miso_pin, dut.dm.memory[0][0]);
		end

		if(dut.fsm.state != 6'b001000) begin
			$display("Test failed: the state is expected to be read0, state is actually %b at time %t", dut.fsm.state, $time);
		end

		sclk = 0; #1000
		sclk = 1; #1000
		if (miso_pin != dut.dm.memory[0][1]) begin
			$display("Test failed at time %t: output of shift register does not match the value of the memory at the correspondong address. miso_pin: %b, memory: %b", $time, miso_pin, dut.dm.memory[0][1]);
		end

		if(dut.fsm.state != 6'b010000) begin
			$display("Test failed: the state is expected to be read1, state is actually %b at time %t", dut.fsm.state, $time);
		end

		sclk = 0; #1000
		sclk = 1; #1000
		if (miso_pin != dut.dm.memory[0][2]) begin
			$display("Test failed at time %t: output of shift register does not match the value of the memory at the correspondong address. miso_pin: %b, memory: %b", $time, miso_pin, dut.dm.memory[0][2]);
		end

		sclk = 0; #1000
		sclk = 1; #1000
		if (miso_pin != dut.dm.memory[0][3]) begin
			$display("Test failed at time %t: output of shift register does not match the value of the memory at the correspondong address. miso_pin: %b, memory: %b", $time, miso_pin, dut.dm.memory[0][3]);
		end

		sclk = 0; #1000
		sclk = 1; #1000
		if (miso_pin != dut.dm.memory[0][4]) begin
			$display("Test failed at time %t: output of shift register does not match the value of the memory at the correspondong address. miso_pin: %b, memory: %b", $time, miso_pin, dut.dm.memory[0][4]);
		end

		sclk = 0; #1000
		sclk = 1; #1000
		if (miso_pin != dut.dm.memory[0][5]) begin
			$display("Test failed at time %t: output of shift register does not match the value of the memory at the correspondong address. miso_pin: %b, memory: %b", $time, miso_pin, dut.dm.memory[0][5]);
		end

		sclk = 0; #1000
		sclk = 1; #1000
		if (miso_pin != dut.dm.memory[0][6]) begin
			$display("Test failed at time %t: output of shift register does not match the value of the memory at the correspondong address. miso_pin: %b, memory: %b", $time, miso_pin, dut.dm.memory[0][6]);
		end


		sclk = 0; #1000
		sclk = 1; #1000
		if (miso_pin != dut.dm.memory[0][7]) begin
			$display("Test failed at time %t: output of shift register does not match the value of the memory at the correspondong address. miso_pin: %b, memory: %b", $time, miso_pin, dut.dm.memory[0][7]);
			$display("%b", dut.fsm.state);
		end

		sclk = 0; #1000
		sclk = 1; #1000

		// Chip select goes high again
		cs = 1;
		sclk = 0; #1000
		sclk = 1; #1000

		if(dut.fsm.state != 6'b100000) begin
			$display("Test failed: the state is expected to be end, state is actually %b at time %t", dut.fsm.state, $time);
		end

		sclk = 0; #1000
		sclk = 1; #1000
		sclk = 0; #1000
		sclk = 1; #1000


		$finish();
		
	end
endmodule