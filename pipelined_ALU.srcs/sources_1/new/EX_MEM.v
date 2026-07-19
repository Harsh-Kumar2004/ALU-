module EX_MEM (
    input  wire       clk,
    input  wire       reset,
    
    input  wire       reg_write_in,      //group of input signals to be forwarded
    input  wire       mem_write_in,
    input  wire       mem_read_in,
    input  wire [7:0] store_data_in,     //Value of the data which is to be stored in the store instruction 

    input  wire [2:0] store_rd_addr,     //Address of the register which the store instruction will store
    input  wire       is_immediate,      //group of signals used in this module
    input  wire [2:0] ALUcontrol,
    input  wire [7:0] rs1_data,
    input  wire [7:0] rs2_data,
    input  wire [7:0] imm_data,
    input  wire [2:0] rs1_addr,
    input  wire [2:0] rs2_addr,
    input  wire [2:0] rd_addr,           //Address of the register at which current instruction will write to 
    
    input  wire [7:0] EXMEM_alu_result,  //Result of instruction running 1 cycle ahead
    input  wire       EXMEM_reg_write,   //whether this instruction (running 1 cycle ahead) will write it's result to register file or not
    input  wire [2:0] EXMEM_rd_addr,     //the address of the register at which it will write the result if it does 
    
    input  wire [7:0] WB_write_back_data,//result of instruction running 2 cycles ahead
    input  wire       MEMWB_reg_write,   //whether this instruction (running 2 cycles ahead) will write it's result to register file or not
    input  wire [2:0] MEMWB_rd_addr,     //the address of the register at which it will write the result if it does

    output reg        reg_write_out,     //group of signals being forwarded
    output reg        mem_read_out,
    output reg        mem_write_out,
    output reg  [2:0] rd_addr_out,
    output reg  [7:0] store_data_out,
    
    output reg  [7:0] alu_result_out     // output of this stage
);
    
    wire [1:0] forwardA,
               forwardB,
               forwardC;
    
    ForwardingUnit fu0 (.rs1_addr(rs1_addr),
                        .rs2_addr(rs2_addr),
                        .store_rd_addr(store_rd_addr),
                        .EXMEM_reg_write(EXMEM_reg_write),
                        .EXMEM_rd_addr(EXMEM_rd_addr),
                        .MEMWB_reg_write(MEMWB_reg_write),
			            .MEMWB_rd_addr(MEMWB_rd_addr),
                        .ForwardA(forwardA),
                        .ForwardB(forwardB),
                        .ForwardC(forwardC));

    reg  [7:0] alu_inA,
   	           alu_inB;
    wire [7:0] alu_result;
	       	
    ALU a0 (.A(alu_inA),
            .B(alu_inB),
            .ALUcontrol(ALUcontrol),
            .ALU_Result(alu_result));

    reg  [7:0] store_data;

    always @(*) begin
        case (forwardA) 
            2'b00  : alu_inA = rs1_data;
            2'b01  : alu_inA = EXMEM_alu_result;
            2'b10  : alu_inA = WB_write_back_data;
            default: alu_inA = rs1_data;
        endcase 
        
        if (is_immediate) alu_inB = imm_data;
        else begin
            case (forwardB)
            2'b00  : alu_inB = rs2_data;
            2'b01  : alu_inB = EXMEM_alu_result;
            2'b10  : alu_inB = WB_write_back_data;
            default: alu_inB = rs2_data; 
            endcase
        end

        case (forwardC)
            2'b00  : store_data = store_data_in;
            2'b01  : store_data = EXMEM_alu_result;
            2'b10  : store_data = WB_write_back_data;
            default: store_data = store_data_in;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_write_out  <= 1'b0;
            mem_read_out   <= 1'b0;
            mem_write_out  <= 1'b0;
            rd_addr_out    <= 3'b000;
            alu_result_out <= 8'b00000000;
            store_data_out <= 8'b00000000;
        end
        else begin
            reg_write_out  <= reg_write_in;
            mem_read_out   <= mem_read_in;
            mem_write_out  <= mem_write_in;
	        rd_addr_out    <= rd_addr;
            alu_result_out <= alu_result;
	        store_data_out <= store_data;
        end
    end
    
endmodule