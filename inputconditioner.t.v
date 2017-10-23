//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`include "inputconditioner.v"

module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    reg  dutpassed;
    reg  shouldChange;
    reg[31:0] i;

    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));

    // Generate clock (50MHz)
    initial clk = 0;
    always #10 clk=!clk;    // 50MHz Clock

    always @ (conditioned) begin
      if($time%20 != 10) begin
        //synchronization test
        dutpassed = 0;
        $display("synchronization failed %d",$time);
      end
      if(!shouldChange) begin
        dutpassed = 0;
        $display("output changed too early on debounce test");
      end
    end
    
    //edge detection
    always @(posedge conditioned) begin
      #1;
      if(!rising) begin
        dutpassed = 0;
        $display("positive edge missed");
      end
      #20;
      if(rising) begin
        dutpassed = 0;
        $display("positive edge pulsed too long");
      end
    end

    always @(negedge conditioned) begin
      #1;
      if(!falling) begin
        dutpassed = 0;
        $display("negative edge missed");
      end
      #20;
      if(rising) begin
        dutpassed = 0;
        $display("negative edge pulsed too long");
      end
    end

    initial begin
    $dumpfile("inputconditioner.vcd");
    $dumpvars(0, testConditioner);
    dutpassed = 1;
    shouldChange = 1;
    pin = 0; #200;
    // Synchronization:
    pin = 0; #5;
    pin = 1; #200;
    if(conditioned != 1) begin
      $display("output did not change on on synchronization test");
      dutpassed = 0;
    end
    pin = 0; #200;
    //Debounces
    shouldChange = 0;
    for(i = 0; i<4; i = i + 1) begin
      pin = 1; #7;
      pin = 0; #3;
    end
    shouldChange = 1;
    pin = 1; #300;
    if(conditioned != 1) begin
      $display("output did not change on on debounce test");
      dutpassed = 0;
    end

    if(dutpassed) begin
      $display("DUT passed");
    end
    else begin
      $display("DUT failed");
    end

    #100;
    $finish();
    end
endmodule
