module WriteBack (
	input wire        mem_read_in,
	input wire  [7:0] alu_result_in,
	input wire  [7:0] load_data_in,

	output wire [7:0] wb_data_out 
	);

	assign wb_data_out = mem_read_in ? load_data_in : alu_result_in; 
endmodule