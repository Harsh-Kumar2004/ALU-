module ID_EX (
    input  wire        clk,
    input  wire        reset,

    input  wire [15:0] instruction_in,

    input  wire [7:0]  wb_data_in,
    input  wire        wb_reg_write_in,
    input  wire [2:0]  wb_rd_addr_in,
    
    output reg         reg_write_out,
    output reg         mem_write_out,
    output reg         mem_read_out,
    output reg         imm_sel_out,
    output reg  [2:0]  alu_control_out,
    
    output reg  [7:0]  rs1_data_out,
    output reg  [7:0]  rs2_data_out,
    output reg  [7:0]  imm_data_out,
    output reg  [7:0]  store_data_out,
    
    output reg  [2:0]  rs1_addr_out,
    output reg  [2:0]  rs2_addr_out,
    output reg  [2:0]  rd_addr_out
); 

    wire       reg_write,
               mem_read,
               mem_write,
               imm_sel;
               
    wire [2:0] alu_control;

    wire [7:0] rs1_data,
               rs2_data,
               store_data;

    Control c1 (.Opcode_in(instruction_in[15:12]),
                .Funct_in(instruction_in[2:0]),

                .reg_write_out(reg_write),
                .mem_read_out(mem_read),
                .mem_write_out(mem_write),
                .imm_sel_out(imm_sel),
                .alu_control_out(alu_control));
               
    RegisterFile f1 (.clk(clk),
                     .wb_reg_write_in(wb_reg_write_in),
                     .wb_rd_addr_in(wb_rd_addr_in),
                     .wb_data_in(wb_data_in),

                     .rs1_addr_in(instruction_in[8:6]),
                     .rs2_addr_in(instruction_in[5:3]),
                     .rd_addr_in(instruction_in[11:9]),

                     .rs1_data_out(rs1_data),
                     .rs2_data_out(rs2_data), 
                     .store_data_out(store_data));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_write_out     <= 1'b0;
            mem_read_out      <= 1'b0;
            mem_write_out     <= 1'b0;
            imm_sel_out       <= 1'b0;
            alu_control_out   <= 3'b000;
            
            rs1_data_out      <= 8'b00000000;
            rs2_data_out      <= 8'b00000000;
            imm_data_out      <= 8'b00000000;
            store_data_out    <= 8'b00000000;

            rs1_addr_out      <= 3'b000;
            rs2_addr_out      <= 3'b000;
            rd_addr_out       <= 3'b000;
        end
	    else begin
            reg_write_out     <= reg_write;
            mem_read_out      <= mem_read;
            mem_write_out     <= mem_write;
            imm_sel_out       <= imm_sel;
            alu_control_out   <= alu_control;
            
            rs1_data_out      <= rs1_data;
            rs2_data_out      <= rs2_data;
            imm_data_out      <= {{2{instruction_in[5]}}, instruction_in[5:0]};
            store_data_out    <= store_data;

            rs1_addr_out      <= instruction_in[8:6];
            rs2_addr_out      <= instruction_in[5:3];
            rd_addr_out       <= instruction_in[11:9];
        end
    end

endmodule