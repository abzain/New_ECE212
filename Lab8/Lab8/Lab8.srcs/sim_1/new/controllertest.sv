module controllertest();
    //inputs
    logic       clk, reset;
    logic [5:0] op, funct;
    logic       zero;
 
    //outputs
    logic       pcen, memwrite, irwrite, regwrite;
    logic       alusrca, iord, memtoreg, regdst;
    logic [1:0] alusrcb, pcsrc;
    logic [2:0] alucontrol;
    
    // instantiate device to be tested
    controller dut(clk, reset, op, funct, zero, 
                   pcen, memwrite, irwrite, regwrite, 
                   alusrca, iord, memtoreg, regdst,
                   alusrcb, pcsrc,alucontrol);
                      
    // generate clock to sequence tests
    always
        begin
          clk <= 1; # 5; clk <= 0; # 5;
        end
    
       
    // initializet est
    initial begin
        reset= 1 ;
        op= 6 'b000000;
        zero =0 ;
        funct= 6 'b000000;
        
        //lw test
        @(posedge clk)#40;
        begin
            reset= 0 ;
            op = 6 'b100011;
            zero= 0 ;
            funct= 6 'b000000;
        end
        
        //sw test
        @(posedge clk)#40;
        begin
            reset= 0 ;
            op = 6 'b101011;
            zero= 0 ;
            funct= 6 'b000000;
        end
        
        //add test
        @(posedge clk)#40;
        begin
            reset= 0 ;
            op = 6 'b000000;
            zero= 0 ;
            funct= 6 'b100000;
        end
        
        //sub test
        @(posedge clk)#40;
        begin
            reset= 0 ;
            op = 6 'b000000;
            zero= 0 ;
            funct= 6 'b100010;
        end
        
        //or test
        @ (posedge clk)#40;
        begin
            reset =0 ;
            op= 6 'b000000;
            zero= 0 ;
            funct =6 'b100101;
        end
        
        //slt test
        @(posedge clk)#40;
        begin
            reset =0 ;
            op= 6 'b000000;
            zero= 0 ;
            funct =6 'b101010;
        end
        
        //beq test
        @(posedge clk)#40;
        begin
            reset= 0 ;
            op = 6 'b000100;
            zero= 1 ;
            funct= 6 'b000000;
        end
        
        //addi test
        @(posedge clk)#40;
        begin
            reset= 0 ;
            op = 6 'b001000;
            zero= 0 ;
            funct= 6 'b000000;
        end
        
        //j test
        @(posedge clk)#40;
        begin
            reset= 0 ;
            op = 6 'b000010;
            zero= 0 ;
            funct= 6 'b000000;
        end
    end
endmodule
    