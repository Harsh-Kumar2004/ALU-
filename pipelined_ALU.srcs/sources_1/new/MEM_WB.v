module MEM_WB (
	input wire       clk, 
	input wire       reset, 

	input wire       reg_write_in,    
    input wire       mem_read_in,
	input wire       mem_write_in,

	input wire [7:0] alu_result_in,  
	input wire [7:0] store_data_in,

	input wire [2:0] rd_addr_in,      

	output reg       reg_write_out,
	output reg       mem_read_out,
	output reg [2:0] rd_addr_out,
	output reg [7:0] load_data_out,
	output reg [7:0] alu_result_out
	);
	
	reg  [7:0] data_mem [0:255];
    wire [7:0] mem_read_wire;

    always @(posedge clk) begin
        if (mem_write_in) begin
            data_mem[alu_result_in] <= store_data_in;
        end
    end

    assign mem_read_wire = (mem_read_in) ? data_mem[alu_result_in] : 8'b00000000;

	always @(posedge clk or posedge reset) begin
		if(reset) begin 
			reg_write_out  <= 1'b0;
			mem_read_out   <= 1'b0;
			rd_addr_out    <= 3'b000;
			load_data_out  <= 8'b00000000;
			alu_result_out <= 8'b00000000;
		end 
		else begin 
			reg_write_out  <= reg_write_in;
			mem_read_out   <= mem_read_in;
			rd_addr_out    <= rd_addr_in;
			alu_result_out <= alu_result_in;
			load_data_out  <= mem_read_wire;
		end	
	end
endmodule