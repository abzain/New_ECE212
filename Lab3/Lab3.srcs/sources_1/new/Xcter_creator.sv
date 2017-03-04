module numGenerator(
    input logic [3:0] num,
    input logic [2:0] col_number,
    output logic [31:0] data);
    
    always_comb
    begin
    data = 32'b0;
        case(num)
        4'd0: //draw 0 through pixels
            begin
                case (col_number)
                3'd1: data = 32'h07777770;
                3'd2: data = 32'h70000007;
                3'd3: data = 32'h70000007;
                3'd4: data = 32'h70000007;
                3'd5: data = 32'h07777770;
                endcase
            end
        4'd1: //draw 1 through pixels
            begin
                case (col_number)
                3'd1: data = 32'h00000000;
                3'd2: data = 32'h70000070;
                3'd3: data = 32'h77777777;
                3'd4: data = 32'h70000000;
                3'd5: data = 32'h00000000;
                endcase
            end
        4'd2: //draw 2 through pixels
            begin
                case (col_number)
                3'd1: data = 32'h77000070;
                3'd2: data = 32'h70700007;
                3'd3: data = 32'h70070007;
                3'd4: data = 32'h70007007;
                3'd5: data = 32'h70000770;
                endcase
            end
        4'd3: //draw 3 through pixels
            begin
                case (col_number)
                3'd1: data = 32'h07000070;
                3'd2: data = 32'h70000007;
                3'd3: data = 32'h70007007;
                3'd4: data = 32'h70007007;
                3'd5: data = 32'h07770770;
                endcase
            end
        4'd4: //draw 4 through pixels
            begin
                case (col_number)
                3'd1: data = 32'h00007777;
                3'd2: data = 32'h00007000;
                3'd3: data = 32'h00007000;
                3'd4: data = 32'h00007000;
                3'd5: data = 32'h77777777;
                endcase
            end
        4'd5: //draw 5 through pixels
            begin
                case (col_number)
                3'd1: data = 32'h07007777;
                3'd2: data = 32'h70007007;
                3'd3: data = 32'h70007007;
                3'd4: data = 32'h70007007;
                3'd5: data = 32'h07770007;
                endcase
            end
        4'd6: //draw 6 through pixels
            begin
                case (col_number)
                3'd1: data = 32'h07777000;
                3'd2: data = 32'h70007700;
                3'd3: data = 32'h70007070;
                3'd4: data = 32'h70007007;
                3'd5: data = 32'h07770000;
                endcase
            end
        4'd7: //draw 7 through pixels
            begin
                case (col_number)
                3'd1: data = 32'h00000007;
                3'd2: data = 32'h77000007;
                3'd3: data = 32'h00770007;
                3'd4: data = 32'h00007707;
                3'd5: data = 32'h00000077;
                endcase
            end
        4'd8: //draw 8 through pixels
            begin
                case (col_number)
                3'd1: data = 32'h07770770;
                3'd2: data = 32'h70007007;
                3'd3: data = 32'h70007007;
                3'd4: data = 32'h70007007;
                3'd5: data = 32'h07770770;
                endcase
            end
        4'd9: //draw 9 through pixels
            begin
                case (col_number)
                3'd1: data = 32'h00000770;
                3'd2: data = 32'h00007007;
                3'd3: data = 32'h00007007;
                3'd4: data = 32'h00007007;
                3'd5: data = 32'h77777770;
                endcase
            end
        endcase
    end
endmodule