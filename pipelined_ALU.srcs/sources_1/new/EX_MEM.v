module EX_MEM (
    input  wire       clk,
    input  wire       reset,
    
    input  wire       reg_write_in,      //group of input control signals
    input  wire       mem_write_in,
    input  wire       mem_read_in,
    input  wire       imm_sel_in,
    input  wire [2:0] alu_control_in,

    input  wire [7:0] store_data_in,     //data which could be potentially stored by the store instruction 
    input  wire [7:0] rs1_data_in,
    input  wire [7:0] rs2_data_in,
    input  wire [7:0] imm_data_in,

    input  wire [2:0] rs1_addr_in,
    input  wire [2:0] rs2_addr_in,
    input  wire [2:0] rd_addr_in,        //Address of the destination register or the address of the register whose data will be stored
    
    input  wire [7:0] mem_alu_result_in, //Result of instruction running 1 cycle ahead
    input  wire       mem_reg_write_in,  //whether this instruction (running 1 cycle ahead) will write it's result to register file or not
    input  wire [2:0] mem_rd_addr_in,    //the address of the register at which it will write the result
    
    input  wire [7:0] wb_data_in,        //result of instruction running 2 cycles ahead
    input  wire       wb_reg_write_in,   //whether this instruction (running 2 cycles ahead) will write it's result to register file or not
    input  wire [2:0] wb_rd_addr_in,     //the address of the register at which it will write the result

    output reg        reg_write_out,     
    output reg        mem_read_out,
    output reg        mem_write_out,

    output reg  [2:0] rd_addr_out,
    output reg  [7:0] store_data_out,
    
    output reg  [7:0] alu_result_out,
    output reg  [3:0] flag_reg_out    
);
    
    wire [1:0] forwardA,
               forwardB,
               forwardS;
    
    ForwardingUnit fu0 (.rs1_addr_in(rs1_addr_in),
                        .rs2_addr_in(rs2_addr_in),
                        .rd_addr_in(rd_addr_in),

                        .mem_reg_write_in(mem_reg_write_in),
                        .mem_rd_addr_in(mem_rd_addr_in),

                        .wb_reg_write_in(wb_reg_write_in),
			            .wb_rd_addr_in(wb_rd_addr_in),

                        .forwardA_out(forwardA),
                        .forwardB_out(forwardB),
                        .forwardS_out(forwardS));

    reg  [7:0] alu_inA,
   	           alu_inB;
    wire [3:0] flag_reg,
               alu_result;
	       	
    ALU a0 (.alu_inA(alu_inA),
            .alu_inB(alu_inB),
            .alu_control_in(alu_control_in),

            .alu_result_out(alu_result),
            .flag_reg_out(flag_reg));

    reg  [7:0] store_data;

    always @(*) begin
        case (forwardA) 
            2'b00  : alu_inA = rs1_data_in;
            2'b01  : alu_inA = mem_alu_result_in;
            2'b10  : alu_inA = wb_data_in;
            default: alu_inA = rs1_data_in;
        endcase 
        
        if (imm_sel_in) alu_inB = imm_data_in;
        else begin
            case (forwardB)
            2'b00  : alu_inB = rs2_data_in;
            2'b01  : alu_inB = mem_alu_result_in;
            2'b10  : alu_inB = wb_data_in;
            default: alu_inB = rs2_data_in; 
            endcase
        end

        case (forwardS)
            2'b00  : store_data = store_data_in;
            2'b01  : store_data = mem_alu_result_in;
            2'b10  : store_data = wb_data_in;
            default: store_data = store_data_in;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_write_out  <= 1'b0;
            mem_read_out   <= 1'b0;
            mem_write_out  <= 1'b0;
            rd_addr_out    <= 3'b000;
            store_data_out <= 8'b00000000;

            flag_reg_out   <= 8'b00000000;
            alu_result_out <= 8'b00000000;
        end
        else begin
            reg_write_out  <= reg_write_in;
            mem_read_out   <= mem_read_in;
            mem_write_out  <= mem_write_in;
	        rd_addr_out    <= rd_addr_in;
            store_data_out <= store_data;

            flag_reg_out   <= flag_reg;
            alu_result_out <= alu_result;
        end
    end
    
endmodule