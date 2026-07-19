module ForwardingUnit (
    input  wire [2:0] rs1_addr_in,       //Address of current operands
    input  wire [2:0] rs2_addr_in,
    input  wire [2:0] rd_addr_in,
    
    input  wire       mem_reg_write_in,  //Address of operand from the instruction 1 cycle ahead and whether it wants to writeback
    input  wire [2:0] mem_rd_addr_in,
   
    input  wire       wb_reg_write_in,   //Address of operand from the instruction 2 cycles ahead and whether it wants to writeback
    input  wire [2:0] wb_rd_addr_in,
    
    output reg  [1:0] forwardA_out,      //Select sigal for the mux which selects operand for the ALU
    output reg  [1:0] forwardB_out,
    output reg  [1:0] forwardS_out 
);
    // if forward == 2'b00, the selected operand is from Register File
    // if forward == 2'b01, the selected operand is from the result computed 1 cycle ahead
    // if forward == 2'b10, the selected operand is from the result computed 2 cycles ahead
    
    always @(*) begin
        forwardA_out = 2'b00;            
        forwardB_out = 2'b00;
        forwardS_out = 2'b00;

        if (mem_reg_write_in &&
           (mem_rd_addr_in != 3'b000) && 
           (mem_rd_addr_in == rs1_addr_in)) begin
            forwardA_out = 2'b01;             
        end
        else if (wb_reg_write_in && 
                (wb_rd_addr_in != 3'b000) &&
                (wb_rd_addr_in == rs1_addr_in)) begin
            forwardA_out = 2'b10;             
        end

        if (mem_reg_write_in &&
           (mem_rd_addr_in != 3'b000) && 
           (mem_rd_addr_in == rs2_addr_in)) begin
            forwardB_out = 2'b01;             
        end
        else if (wb_reg_write_in && 
                (wb_rd_addr_in != 3'b000) &&
                (wb_rd_addr_in == rs2_addr_in)) begin
            forwardB_out = 2'b10;             
        end

        if (mem_reg_write_in &&
           (mem_rd_addr_in != 3'b000) && 
           (mem_rd_addr_in == rd_addr_in)) begin
            forwardS_out = 2'b01;             
        end
        else if (wb_reg_write_in && 
                (wb_rd_addr_in != 3'b000) &&
                (wb_rd_addr_in == rd_addr_in)) begin
            forwardS_out = 2'b10;             
        end
    end

endmodule