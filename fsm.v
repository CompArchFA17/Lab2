module fsm
(
input 	    shiftRegOut,            //defines the state (read or write)
input	    CS,						//chip select
input 		sclk,    			//serial clock
input clk, // system clock
output reg	    MISOBUFE,    // controls output to MISO
output reg 	    DM_WE,   // Write enable data memory
output reg      ADDR_WE,    //  address write enable
output reg		SR_WE //Parallel Load
);
  reg[3:0] counter = 0;
  reg[5:0] currentState = 0;
  // states:
  // 0 - default
  // 1 - accepting address- ADDR_WE is enabled
  // 2 - accepting r/w bit- ADDR_WE is disabled
  // 3 - first reading state: setting WE high
  // 4 - second reading state: setting WE low
  // 5 - final reading state: output to buffer
  // 6 - first write state: accepting data - need to accept 8 more data bits
  // 7 - writing to DM: sets everything to zero once writing is done
    
  always @(posedge clk) begin
    if (sclk) begin
      case(currentState) 
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
          if(counter == 6) begin
          	currentState <= 2;
            counter <= 0; //reset counter
          end
        end
      
        2: begin // Accepting Read/Write Bit
          ADDR_WE <= 0;
          if (shiftRegOut == 1) begin
          	currentState <= 3;
          end
          else begin
          	currentState <= 6;
          end
        end
        
        3: begin // First read state, set WE high
          SR_WE <= 1;
          currentState <= 4; 
        end
        
        4: begin // Second read state, set WE low
        	SR_WE <= 0;
          currentState <= 5;
        end
        
        5: begin 
          MISOBUFE <= 1;
          counter <= counter + 1; 
          if (counter == 7) begin
            currentState <= 0;
            counter <= 0;
          end
        end
        
        6: begin // allowing shift register to accept 8 bits of data
          if (counter == 7) begin
            DM_WE <= 1;
            currentState <= 7;
            counter <= 0;
          end
          else begin
            counter <= counter + 1;
          end
        end
        
        7: begin // writing to DM for one clock cycle (DM is already high by the time this is reached)
          DM_WE <= 0;
          currentState <= 0;
        end
      endcase
    end
  end
endmodule
