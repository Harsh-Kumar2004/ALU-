`timescale 1ns / 1ps

module tb_CPU_top;
    reg clk;
    reg reset;

    CPU_Top my_cpu (
        .clk(clk),
        .reset(reset)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        reset = 1;
        #20 reset = 0;
        #1000 $finish;
    end
    
    initial begin
        $monitor("Time=%0t | PC = %b | Instruction = %b", $time, my_cpu.stage0.pc, my_cpu.stage0.fetched_instruction);
    end

endmodule