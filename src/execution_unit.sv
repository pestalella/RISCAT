`timescale 1ns / 1ps

module exec_unit (
    input  wire clk,
    input  wire reset_n,

    output wire rd_ram_en,
    output wire [31:0] rd_ram_addr,
    input  wire [31:0] rd_ram_data,

    output wire wr_ram_en,
    output wire [31:0] wr_ram_addr,
    output wire [31:0] wr_ram_data,
);

  logic [31:0] pc;

	wire [31:0] regfile_rd0_data;
	wire [31:0] regfile_rd1_data;
  wire [31:0] reg_wr_data;
	logic [4:0] reg_rd0_addr;
	logic [4:0] reg_rd1_addr;
	logic [4:0] reg_wr_addr;
	logic reg_rd0_en;
	logic reg_rd1_en;
	logic reg_wr_en;

	register32bit_file registers(
		.clk(clk),
		.reset_n(reset_n),

		.rd0_enable(reg_rd0_en),
		.rd0_addr(reg_rd0_addr),
		.rd0_data(regfile_rd0_data),

		.rd1_enable(reg_rd1_en),
		.rd1_addr(reg_rd1_addr),
		.rd1_data(regfile_rd1_data),

		.wr_enable(reg_wr_en),
		.wr_addr(reg_wr_addr),
		.wr_data(reg_wr_data)
	);

	// Update program counter
	always @(posedge clk) begin
			if (!reset_n) begin
					pc  <= 0;
			end else begin
					pc  <= pc + 4;
			end
	end

	// Clear internal data on reset
  always @(posedge clk) begin
    if (!reset_n) begin
			reg_rd0_addr <= '0;
			reg_rd1_addr <= '0;
			reg_wr_addr <= '0;
			reg_rd0_en <= '0;
			reg_rd1_en <= '0;
			reg_wr_en <= '0;
		end
	end

endmodule
