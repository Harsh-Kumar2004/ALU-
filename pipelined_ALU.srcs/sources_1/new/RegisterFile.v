module RegisterFile (
    input  wire       clk,
    input  wire       reg_write,
    input  wire [2:0] rs1_addr,
    input  wire [2:0] rs2_addr,
    input  wire [2:0] store_rd_addr,

    input  wire [2:0] write_addr,
    input  wire [7:0] write_data, 
    
    output wire [7:0] rs1_data,
    output wire [7:0] rs2_data,
    output wire [7:0] store_data
);

    reg [7:0] reg_file [0:7];

    assign rs1_data   = (rs1_addr == 3'b000) ? 8'b00000000 : reg_file[rs1_addr];
    assign rs2_data   = (rs2_addr == 3'b000) ? 8'b00000000 : reg_file[rs2_addr];
    assign store_data = (store_rd_addr == 3'b000) ? 8'b00000000 : reg_file[store_rd_addr];

    always @(posedge clk) begin
        if (reg_write && (write_addr != 3'b000)) begin
            reg_file[write_addr] <= write_data;
        end
    end

endmodule