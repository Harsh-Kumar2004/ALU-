module InstructionMemory (
    input  wire [7:0]  pc_in,          
    output wire [15:0] instruction_out
);

    reg [15:0] rom [0:255];
    initial begin
        // $readmemb("program.bin", rom);
    end
    assign instruction_out = rom[pc_in];

endmodule