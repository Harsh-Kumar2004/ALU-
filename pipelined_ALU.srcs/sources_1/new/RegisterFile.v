module RegisterFile (
    input  wire       clk,

    input  wire       wb_reg_write_in,   
    input  wire [2:0] wb_rd_addr_in,
    input  wire [7:0] wb_data_in,

    input  wire [2:0] rs1_addr_in,
    input  wire [2:0] rs2_addr_in,
    input  wire [2:0] rd_addr_in, 
    
    output wire [7:0] rs1_data_out,
    output wire [7:0] rs2_data_out,
    output wire [7:0] store_data_out
);

    reg [7:0] reg_file [0:7];

    assign rs1_data_out   = (rs1_addr_in == 3'b000) ? 8'b00000000 : reg_file[rs1_addr_in];
    assign rs2_data_out   = (rs2_addr_in == 3'b000) ? 8'b00000000 : reg_file[rs2_addr_in];
    assign store_data_out = (rd_addr_in == 3'b000) ? 8'b00000000 : reg_file[rd_addr_in];

    always @(posedge clk) begin
        if (wb_reg_write_in && (wb_rd_addr_in != 3'b000)) begin
            reg_file[wb_rd_addr_in] <= wb_data_in;
        end
    end

endmodule