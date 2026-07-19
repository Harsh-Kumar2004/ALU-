
module IF_ID (
    input  wire        clk,
    input  wire        reset,

    output reg  [15:0] instruction_out
);

    reg  [7:0]  pc;
    wire [7:0]  next_pc;
    wire [15:0] fetched_instruction;

    assign next_pc = pc + 8'b00000001;

    InstructionMemory imem (
        .pc_in(pc),
        .instruction_out(fetched_instruction)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 8'b00000000;
            instruction_out <= 16'h0000;
        end else begin
            pc <= next_pc;
            instruction_out <= fetched_instruction;
        end
    end

endmodule