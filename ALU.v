module ALU (
    input  wire [7:0] A,          
    input  wire [7:0] B,          
    input  wire [2:0] ALUcontrol, 
    output reg  [7:0] ALU_Result
);

    always @(*) begin
        case (ALUcontrol)
            3'b000: ALU_Result = A + B;       // ADD / LDR / STR / ADDI
            3'b001: ALU_Result = A - B;       // SUB / SUBI
            3'b010: ALU_Result = A & B;       // AND / ANDI
            3'b011: ALU_Result = A | B;       // OR / ORI
            3'b100: ALU_Result = A ^ B;       // XOR / XORI
            3'b101: ALU_Result = ~(A | B);    // NOR
            3'b110: ALU_Result = A << B[2:0]; // LSL (shift by lower 3 bits)
            3'b111: ALU_Result = A >> B[2:0]; // LSR (shift by lower 3 bits)
            default: ALU_Result = 8'b00000000;
        endcase
    end

endmodule