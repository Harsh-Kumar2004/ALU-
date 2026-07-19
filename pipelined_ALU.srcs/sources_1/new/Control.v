module Control (
    input  wire [3:0] Opcode_in,
    input  wire [2:0] Funct_in,
    
    output wire       reg_write_out,
    output wire       mem_read_out,
    output wire       mem_write_out,
    output wire       imm_sel_out,
    output reg  [2:0] alu_control_out
);

    wire is_Rtype = (Opcode_in == 4'b0000);
    wire is_Itype = Opcode_in[3]; 
    wire is_LDR   = (Opcode_in == 4'b0100);
    wire is_STR   = (Opcode_in == 4'b0101);

    assign reg_write_out = is_Rtype | is_Itype | is_LDR;
    assign mem_read_out  = is_LDR;
    assign mem_write_out = is_STR;
    assign imm_sel_out   = is_Itype | is_LDR | is_STR;

    always @(*) begin
	case ({is_Rtype, is_Itype})
	    2'b10   : alu_control_out = Funct_in;
	    2'b01   : alu_control_out = Opcode_in[2:0];
	    default : alu_control_out = 3'b000; 
	endcase	 
    end

endmodule