module CPU_Top (
    input  wire clk,
    input  wire reset
);

// --- IF Stage Signals ---
wire [15:0] if_instruction;

// --- ID Stage Signals ---
wire        id_reg_write_out;
wire        id_mem_read_out;
wire        id_mem_write_out;
wire        id_is_immediate_out;
wire [2:0]  id_ALUcontrol_out;
wire [7:0]  id_rs1_data_out;
wire [7:0]  id_rs2_data_out;
wire [7:0]  id_imm_data_out;
wire [2:0]  id_rs1_addr_out;
wire [2:0]  id_rs2_addr_out;
wire [2:0]  id_rd_addr_out;
wire [2:0]  id_store_rd_addr_out;

// --- EX Stage Signals ---
wire        ex_reg_write_out;
wire        ex_mem_read_out;
wire        ex_mem_write_out;
wire [2:0]  ex_rd_addr_out;
wire [7:0]  ex_alu_result_out;
wire [7:0]  ex_store_data_out;

// --- MEM Stage Signals ---
wire        mem_reg_write_out;
wire [2:0]  mem_rd_addr_out;
wire [7:0]  mem_load_data_out;
wire [7:0]  mem_alu_result_out;

// --- WB Stage Signal ---
wire [7:0]  wb_data;

// IF/ID Module
IF_ID if_id_stage (.clk(clk),
                   .reset(reset),
                   .instruction_out(if_instruction));


// ID/EX Module
ID_EX id_ex_stage (.clk(clk),
                   .reset(reset),
                   .instruction(if_instruction),
                   .write_data(wb_data),
                   .wb_reg_write(mem_reg_write_out),
                   .write_addr(mem_rd_addr_out),
                   .reg_write_out(id_reg_write_out),
                   .mem_read_out(id_mem_read_out),
                   .mem_write_out(id_mem_write_out),
                   .is_immediate_out(id_is_immediate_out),
                   .ALUcontrol_out(id_ALUcontrol_out),
                   .rs1_data_out(id_rs1_data_out),
                   .rs2_data_out(id_rs2_data_out),
                   .imm_data_out(id_imm_data_out),
                   .rs1_addr(id_rs1_addr_out),
                   .rs2_addr(id_rs2_addr_out),
                   .store_rd_addr(id_store_rd_addr_out),
                   .rd_addr(id_rd_addr_out));

// EX/MEM Module
EX_MEM ex_mem_stage (.clk(clk),
                     .reset(reset),
                     .reg_write_in(id_reg_write_out),
                     .mem_write_in(id_mem_write_out),
                     .mem_read_in(id_mem_read_out),
                     .store_data_in(id_rs2_data_out),
                     .store_rd_addr(id_store_rd_addr_out),
                     .is_immediate(id_is_immediate_out),
                     .ALUcontrol(id_ALUcontrol_out),
                     .rs1_data(id_rs1_data_out),
                     .rs2_data(id_rs2_data_out),
                     .imm_data(id_imm_data_out),
                     .rs1_addr(id_rs1_addr_out),
                     .rs2_addr(id_rs2_addr_out),
                     .rd_addr(id_rd_addr_out),
                     .EXMEM_alu_result(ex_alu_result_out),
                     .EXMEM_reg_write(ex_reg_write_out),
                     .EXMEM_rd_addr(ex_rd_addr_out),
                     .WB_write_back_data(wb_data),
                     .MEMWB_reg_write(mem_reg_write_out),
                     .MEMWB_rd_addr(mem_rd_addr_out),
                     .reg_write_out(ex_reg_write_out),
                     .mem_read_out(ex_mem_read_out),
                     .mem_write_out(ex_mem_write_out),
                     .rd_addr_out(ex_rd_addr_out),
                     .store_data_out(ex_store_data_out),
                     .alu_result_out(ex_alu_result_out));

// MEM/WB Module
MEM_WB mem_wb_stage (.clk(clk),
                     .reset(reset),
                     .reg_write_in(ex_reg_write_out),
                     .mem_read_in(ex_mem_read_in_logic_proxy), // Placeholder logic
                     .alu_result_in(ex_alu_result_out),
                     .mem_write(ex_mem_write_out),
                     .store_data(ex_store_data_out),
                     .rd_add_in(ex_rd_addr_out),
                     .reg_write_out(mem_reg_write_out),
                     .mem_read_out(dummy_mem_read),
                     .rd_add_out(mem_rd_addr_out),
                     .load_data(mem_load_data_out),
                     .alu_result_out(mem_alu_result_out));

// WriteBack Logic
WriteBack wb_stage (.was_mem_read(dummy_mem_read),
                    .alu_result(mem_alu_result_out),
                    .load_data(mem_load_data_out),
                    .write_back_data(wb_data)
);

// Dummy signal logic for connectivity
wire ex_mem_read_in_logic_proxy = ex_mem_read_out;
wire dummy_mem_read;


endmodule