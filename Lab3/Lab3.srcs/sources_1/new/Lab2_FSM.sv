`timescale 1ns / 1ps
module fsm(
    input logic clk, reset, 
    output logic  en_col, en_wait, en_row, OE, lat, clk_shift
    );
    
  //logic
  logic [4:0] col_cnt;
  logic threeNs_clk;
  logic [8:0] wait_cnt;
    
  parameter BAUD = 3000000;  // desired frequency in Hz 1/300ns
  
   //instantiate modules
  clkdiv #(.DIVFREQ(BAUD)) hold300ns(.clk(clk), .reset(reset), .sclk(threeNs_clk));  
  col_counter U_col( .clk(threeNs_clk) , .reset(reset), .enb(en_col),  .q(col_cnt) );
  wait_counter U_wait( .clk(threeNs_clk), .reset(reset), .enb(en_wait),  .q(wait_cnt) );
 
  
  typedef enum logic [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100,
        WAIT = 3'b101
        } states_t;
        
        states_t state, next;
        
        always_ff @(posedge threeNs_clk) //ensure each control signal held for 200ns
         if (reset)  state <= S0;
         else state <= next;    
        
        always_comb begin 
            next = S0;
            clk_shift = 0; 
            lat = 0;
            OE = 0;
            en_row = 0;
            en_col = 0;
            en_wait = 0; 
            case( state )
            
            S0: //default state
                begin
                  next = S1;
                  lat = 0;
                  OE = 0;   //high
                  en_row = 0;
                  en_col = 1;
                  clk_shift = 0; 
                  en_wait = 0; 
                end
            S1: //fill all columns
                begin 
                    lat = 0;
                    OE = 0;   //high
                    en_row = 0;
                    en_col = 0;
                    clk_shift = 1; 
                    en_wait = 0; 
                    
                    if (col_cnt == 5'd31 ) 
                        begin next = S2; end  
                    else 
                        begin next = S0; end
                end   
                
            S2: //turn off display 
                begin
                    next = S3;
                    lat = 0;
                    OE = 1;   //low
                    en_row = 0;
                    en_col = 0;
                    clk_shift = 0; 
                    en_wait = 0; 
                end
            S3: // enable row to update ABC 
                begin
                    next = S4;
                    lat = 0;
                    OE = 1;   //low
                    en_row = 1;
                    en_col = 0;
                    clk_shift = 0; 
                    en_wait = 0; 
                end
            S4: //shift values to latch and turn display off while shifting
                begin
                    next = WAIT;
                    lat = 1;
                    OE = 1;   //low
                    en_row = 0;
                    en_col = 0;
                    clk_shift = 0; 
                    en_wait = 0; 
                end
            WAIT: 
             //wait time for LED's to fully turn on, 100 times/s per row, thus count till o.o1s 
             //(using a counter that is enabled with a 300ns clock (100 times/sec)
             //chose 300 times
                begin 
                    lat = 0;
                    OE = 0;   //high
                    en_row = 0;
                    en_col = 0;
                    clk_shift = 0; 
                    en_wait = 1; 
                    
                    if (wait_cnt < 9'd300 ) 
                        begin next = WAIT; end  
                    else 
                        begin next = S0; end
                end

            default:
                begin
                    next = S0;
                    lat = 0;
                    OE = 0;   //high
                    en_row = 0;
                    en_col = 0;
                    clk_shift = 0; 
                    en_wait = 0; 
                end
            endcase
        end 
endmodule
