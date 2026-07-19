module InstructionMemory (
    input  wire [7:0]  pc,         
    output wire [15:0] instruction
);

    reg [15:0] rom [0:255];
    initial begin
        //$readmemb("program.bin", rom);
    end
    assign instruction = rom[pc];

endmodule