module fsm
(
input 	    shiftRegOut,            //defines the state (read or write)
input	    CS,						//chip select
input 		sclk,    			//serial clock
output	    MISOBUFE,    // controls output to MISO
output 	    DM_WE,   // Write enable data memory
output      ADDR_WE,    //  address write enable
output		SR_WE //Parallel Load
);
reg[3:0] counter;
wire[5:0] currentState;
// states:
// 0 - default
// 1 - accepting address- ADDR_WE is enabled
// 2 - accepting r/w bit- ADDR_WE is disabled
// 3 - first reading state: setting WE high
// 4 - second reading state: setting WE low
// 5 - final reading state: output to buffer
// 6 - first write state: accepting data - need to accept 8 more data bits
// 7 - writing to DM: sets everything to zero once writing is done
  
counter <= 0;
defaultState <= 0;

currentState <= defaultState;
always @(posedge sclk) begin
  case(currentState) begin
    0: begin // Default State
      if (CS == 0) begin
        currentState <= 1;
      end
      else begin
        // we need to set everything to zero here just in case
        MISOBUFE <= 0;
        DM_WE <= 0;
        ADDR_WE <= 0;
        SR_WE <=0;
        counter <= 0;
      end
    end
    
    1: begin // Accepting Address
      ADDR_WE <=1;
      counter <= counter + 1;
      if(counter==3'b6) begin
      	currentState<=2;
        counter <=3'b0; //reset counter
      end