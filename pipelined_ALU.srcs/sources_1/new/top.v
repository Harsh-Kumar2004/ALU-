module CPU_Top (
    input  wire clk,
    input  wire reset
);

    // signals from stage0 to stage1
    wire [15:0] instruction_01;

    // signals from stage1 to stage2
    wire        reg_write_12;
    wire        mem_read_12;
    wire        mem_write_12;
    wire        imm_sel_12;
    wire [2:0]  alu_control_12;

    wire [7:0]  rs1_data_12;
    wire [7:0]  rs2_data_12;
    wire [7:0]  imm_data_12;
    wire [7:0]  store_data_12;

    wire [2:0]  rs1_addr_12;
    wire [2:0]  rs2_addr_12;
    wire [2:0]  rd_addr_12;

    // signals from stage2 to 3
    wire        mem_read_23;
    wire        mem_write_23;
    wire [7:0]  store_data_23;
    wire [3:0]  flag_reg_2;
    // signals from stage2 to 3 as well as creating feedback to stage2
    wire [7:0]  alu_result_22_23;
    wire        reg_write_22_23;
    wire [2:0]  rd_addr_22_23;

    // signals from stage3 to 4
    wire        mem_read_34;
    wire [7:0]  load_data_34;
    wire [7:0]  alu_result_34;
    // signals forming feedback from stage 3 to 1 and 2
    wire        reg_write_31_32;
    wire [2:0]  rd_addr_31_32;

    // signals coming out of stage 4 and feeding back to stage 1 and 2
    wire [7:0]  wb_data_41_42;

    // signal_01 means signal coming out of stage 0 and going into stage 1
    IF_ID stage0 (
        .clk(clk),
        .reset(reset),

        .instruction_out(instruction_01));


    ID_EX stage1 (
        .clk(clk),
        .reset(reset),

        .instruction_in(instruction_01),

        .wb_data_in(wb_data_41_42),
        .wb_reg_write_in(reg_write_31_32),
        .wb_rd_addr_in(rd_addr_31_32),

        .reg_write_out(reg_write_12),
        .mem_write_out(mem_write_12),
        .mem_read_out(mem_read_12),
        .imm_sel_out(imm_sel_12),
        .alu_control_out(alu_control_12),

        .rs1_data_out(rs1_data_12),
        .rs2_data_out(rs2_data_12),
        .imm_data_out(imm_data_12),
        .store_data_out(store_data_12),

        .rs1_addr_out(rs1_addr_12),
        .rs2_addr_out(rs2_addr_12),
        .rd_addr_out(rd_addr_12));


    EX_MEM stage2 (
        .clk(clk),
        .reset(reset),

        .reg_write_in(reg_write_12),
        .mem_write_in(mem_write_12),
        .mem_read_in(mem_read_12),
        .imm_sel_in(imm_sel_12),
        .alu_control_in(alu_control_12),

        .store_data_in(store_data_12),
        .rs1_data_in(rs1_data_12),
        .rs2_data_in(rs2_data_12),
        .imm_data_in(imm_data_12),

        .rs1_addr_in(rs1_addr_12),
        .rs2_addr_in(rs2_addr_12),
        .rd_addr_in(rd_addr_12),

        .mem_alu_result_in(alu_result_22_23),
        .mem_reg_write_in(reg_write_22_23),
        .mem_rd_addr_in(rd_addr_22_23),

        .wb_data_in(wb_data_41_42),
        .wb_reg_write_in(reg_write_31_32),
        .wb_rd_addr_in(rd_addr_31_32),

        .reg_write_out(reg_write_22_23),
        .mem_read_out(mem_read_23),
        .mem_write_out(mem_write_23),

        .rd_addr_out(rd_addr_22_23),
        .store_data_out(store_data_23),

        .alu_result_out(alu_result_22_23),
        .flag_reg_out(flag_reg_2));


    MEM_WB stage3 (
        .clk(clk),
        .reset(reset),

        .reg_write_in(reg_write_22_23),
        .mem_read_in(mem_read_23), 
        .mem_write_in(mem_write_23),

        .alu_result_in(alu_result_22_23),
        .store_data_in(store_data_23),

        .rd_addr_in(rd_addr_22_23),

        .reg_write_out(reg_write_31_32),
        .mem_read_out(mem_read_34),
        .rd_addr_out(rd_addr_31_32),
        .load_data_out(load_data_34),
        .alu_result_out(alu_result_34));


    WriteBack stage4 (
        .mem_read_in(mem_read_34),
        .alu_result_in(alu_result_34),
        .load_data_in(load_data_34),

        .wb_data_out(wb_data_41_42));

endmodule