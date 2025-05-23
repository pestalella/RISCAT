`timescale 1ns / 1ps

interface exec_unit_if(
	input logic clk,
	output logic reset_n
);

	logic rd_ram_en;
	logic [31:0] rd_ram_addr;
	logic [31:0] rd_ram_data;
	logic wr_ram_en;
	logic [31:0] wr_ram_addr;
	logic [31:0] wr_ram_data;

endinterface


module exec_unit (
    // input  wire clk,
    // input  wire reset_n,

    // output wire rd_ram_en,
    // output wire [31:0] rd_ram_addr,
    // input  wire [31:0] rd_ram_data,

    // output wire wr_ram_en,
    // output wire [31:0] wr_ram_addr,
    // output wire [31:0] wr_ram_data
		exec_unit_if exec_if
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


	regfile_if regfile_interface();

	assign regfile_interface.clk = exec_if.clk;
	assign regfile_interface.reset_n = exec_if.reset_n;
	assign regfile_interface.rd0_en = reg_rd0_en;
	assign regfile_interface.rd0_addr = reg_rd0_addr;
	assign regfile_interface.rd0_data = regfile_rd0_data;
	assign regfile_interface.rd1_en = reg_rd1_en;
	assign regfile_interface.rd1_addr = reg_rd1_addr;
	assign regfile_interface.rd1_data = regfile_rd1_data;
	assign regfile_interface.wr_en = reg_wr_en;
	assign regfile_interface.wr_addr = reg_wr_addr;
	assign regfile_interface.wr_data = reg_wr_data;

	register32bit_file registers(
		.reg_if(regfile_interface)
	);

	// Update program counter
	always @(posedge exec_if.clk) begin
			if (!exec_if.reset_n) begin
					pc  <= 0;
			end else begin
					pc  <= pc + 4;
			end
	end

	// Clear internal data on reset
  always @(posedge exec_if.clk) begin
    if (!exec_if.reset_n) begin
			reg_rd0_addr <= '0;
			reg_rd1_addr <= '0;
			reg_wr_addr <= '0;
			reg_rd0_en <= '0;
			reg_rd1_en <= '0;
			reg_wr_en <= '0;
		end
	end

endmodule
