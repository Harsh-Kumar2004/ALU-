module ID_EX (
    input  wire        clk,
    input  wire        reset,
    input  wire [15:0] instruction,

    input  wire [7:0]  write_data,
    input  wire        wb_reg_write,
    input  wire [2:0]  write_addr,
    
    output reg         reg_write_out,
    output reg         mem_write_out,
    output reg         mem_read_out,
    output reg         is_immediate_out,
    output reg  [2:0]  ALUcontrol_out,
    
    output reg  [7:0]  rs1_data_out,
    output reg  [7:0]  rs2_data_out,
    output reg  [7:0]  imm_data_out,
    output reg  [7:0]  store_data_out,
    
    output reg  [2:0]  rs1_addr,
    output reg  [2:0]  rs2_addr,
    output reg  [2:0]  store_rd_addr,
    output reg  [2:0]  rd_addr
); 

    wire       reg_write,
               mem_read,
               mem_write,
               is_immediate;
               
    wire [2:0] ALUcontrol;

    wire [7:0] rs1_data,
               rs2_data,
               store_data;

    Control c1 (.Opcode(instruction[15:12]),
                .Funct(instruction[2:0]),
                .reg_write(reg_write),
                .mem_read(mem_read),
                .mem_write(mem_write),
                .isimm_operand(is_immediate),
                .ALUcontrol(ALUcontrol));
               
    RegisterFile f1 (.clk(clk),
                     .reg_write(wb_reg_write),
                     .rs1_addr(instruction[8:6]),
                     .rs2_addr(instruction[5:3]),
                     .store_rd_addr(instruction[11:9]),
                     .write_addr(write_addr),
                     .write_data(write_data),
                     .rs1_data(rs1_data),
                     .rs2_data(rs2_data),
                     .store_data(store_data));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_write_out     <= 1'b0;
            mem_read_out      <= 1'b0;
            mem_write_out     <= 1'b0;
            is_immediate_out  <= 1'b0;
            ALUcontrol_out    <= 3'b000;
            
            rs1_data_out      <= 8'b00000000;
            rs2_data_out      <= 8'b00000000;
            imm_data_out      <= 8'b00000000;
            store_data_out    <= 8'b00000000;

            rs1_addr          <= 3'b000;
            rs2_addr          <= 3'b000;
            store_rd_addr     <= 3'b000;
            rd_addr           <= 3'b000;
        end
	    else begin
            reg_write_out     <= reg_write;
            mem_read_out      <= mem_read;
            mem_write_out     <= mem_write;
            is_immediate_out  <= is_immediate;
            ALUcontrol_out    <= ALUcontrol;
            
            rs1_data_out      <= rs1_data;
            rs2_data_out      <= rs2_data;
            imm_data_out      <= {{2{instruction[5]}}, instruction[5:0]};
            store_data_out    <= store_data;

            rs1_addr          <= instruction[8:6];
            rs2_addr          <= instruction[5:3];
            store_rd_addr     <= instruction[11:9];
            rd_addr           <= instruction[11:9];
        end
    end

endmodule