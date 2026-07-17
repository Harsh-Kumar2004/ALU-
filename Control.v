module Control (
    input  wire [3:0] Opcode,
    input  wire [2:0] Funct,
    
    output wire       reg_write,
    output wire       mem_read,
    output wire       mem_write,
    output wire       isimm_operand,
    output reg  [2:0] ALUcontrol
);

    wire is_Rtype = (Opcode == 4'b0000);
    wire is_Imath = Opcode[3]; 
    wire is_LDR   = (Opcode == 4'b0100);
    wire is_STR   = (Opcode == 4'b0101);

    assign reg_write      = is_Rtype | is_Imath | is_LDR;
    assign mem_read       = is_LDR;
    assign mem_write      = is_STR;
    assign isimm_operand = is_Imath | is_LDR | is_STR;

    always @(*) begin
	case ({is_Rtype, is_Imath})
	    2'b10   : ALUcontrol = Funct;
	    2'b01   : ALUcontrol = Opcode[2:0];
	    default : ALUcontrol = 3'b000; 
	endcase	 
    end

endmodule