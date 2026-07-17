module WriteBack(
	input wire        was_mem_read,
	input wire  [7:0] alu_result,
	input wire  [7:0] load_data,

	output wire [7:0] write_back_data 
	);

	assign write_back_data = was_mem_read ? load_data : alu_result; 
endmodule