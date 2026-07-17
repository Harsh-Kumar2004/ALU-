module ForwardingUnit (
    input  wire [2:0] rs1_addr,          //Address of current operands
    input  wire [2:0] rs2_addr,
    input  wire [2:0] store_rd_addr,     //Address of the register which the store instruction will store
    
    input  wire       EXMEM_reg_write,   //Address of operand from the instruction 1 cycle ahead and whether it wants to writeback
    input  wire [2:0] EXMEM_rd_addr,
   
    input  wire       MEMWB_reg_write,   //Address of operand from the instruction 2 cycles ahead and whether it wants to writeback
    input  wire [2:0] MEMWB_rd_addr,
    
    output reg  [1:0] ForwardA,          //Select bus for the mux which selects operand for the ALU
    output reg  [1:0] ForwardB,
    output reg  [1:0] ForwardC 
);

    always @(*) begin
        ForwardA = 2'b00;                //This value of select signal selects the operands coming from register file
        ForwardB = 2'b00;
        ForwardC = 2'b00;

        if (EXMEM_reg_write &&
           (EXMEM_rd_addr != 3'b000) && 
           (EXMEM_rd_addr == rs1_addr)) begin
            ForwardA = 2'b01;            //This value of select signal selects the operand as the result of instruction 1 cycle ahead 
        end
        else if (MEMWB_reg_write && 
                (MEMWB_rd_addr != 3'b000) &&
                (MEMWB_rd_addr == rs1_addr)) begin
            ForwardA = 2'b10;            //This value of select signal selects the operand as the result of instruction 2 cycles ahead 
        end

        if (EXMEM_reg_write &&
           (EXMEM_rd_addr != 3'b000) && 
           (EXMEM_rd_addr == rs2_addr)) begin
            ForwardB = 2'b01;             
        end
        else if (MEMWB_reg_write &&
                (MEMWB_rd_addr != 3'b000) && 
                (MEMWB_rd_addr == rs2_addr)) begin
            ForwardB = 2'b10;            
        end

        if (EXMEM_reg_write &&
           (EXMEM_rd_addr != 3'b000) && 
           (EXMEM_rd_addr == store_rd_addr)) begin
            ForwardC = 2'b01;            
        end
        else if (MEMWB_reg_write && 
                (MEMWB_rd_addr != 3'b000) &&
                (MEMWB_rd_addr == store_rd_addr)) begin
            ForwardC = 2'b10;             
        end
    end

endmodule