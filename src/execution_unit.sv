
`include "alu_enums.svh"
`include "register32bit_file.sv"
`include "fetch_unit.sv"
`include "decode_unit.sv"
`include "alu.sv"

interface exec_unit_if(
	input logic clk,
	output logic reset_n
);

	wire rd_ram_en;
	logic [31:0] rd_ram_addr;
	logic [31:0] rd_ram_data;
	wire wr_ram_en;
	logic [31:0] wr_ram_addr;
	logic [31:0] wr_ram_data;

endinterface

module exec_unit (
		exec_unit_if exec_if
);

  logic [31:0] pc;

	wire [31:0] regfile_rd0_data;
	wire [31:0] regfile_rd1_data;
  wire [31:0] reg_wr_data;

	logic [4:0] decode_reg_rd0_addr;
	logic [4:0] decode_reg_rd1_addr;
	logic [4:0] decode_reg_wr_addr;
	logic decode_reg_rd0_en;
	logic decode_reg_rd1_en;
	logic decode_reg_wr_en;
	logic decode_input_a_is_immediate;
	logic [11:0] decode_inst_imm;
	alu_command_t decode_alu_op;
  logic [31:0] alu_result;

	logic reg_store_wr_en;
	logic [4:0] reg_store_wr_addr;
  logic [31:0] reg_store_wr_data;

	// always read a new instruction
	assign exec_if.rd_ram_en = 1;

	regfile_if regfile_interface();

	assign regfile_interface.clk = exec_if.clk;
	assign regfile_interface.reset_n = exec_if.reset_n;
	assign regfile_interface.rd0_en = decode_reg_rd0_en;
	assign regfile_interface.rd0_addr = decode_reg_rd0_addr;
	assign regfile_rd0_data = regfile_interface.rd0_data;
	assign regfile_interface.rd1_en = decode_reg_rd1_en;
	assign regfile_interface.rd1_addr = decode_reg_rd1_addr;
	assign regfile_rd1_data = regfile_interface.rd1_data;
	assign regfile_interface.wr_en = reg_store_wr_en & alu_result_ready;
	assign regfile_interface.wr_addr = reg_store_wr_addr;
	assign regfile_interface.wr_data = reg_store_wr_data;

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
		end
	end

	logic fetch_started;
	logic fetch_completed;
	wire [31:0] fetched_inst;
	logic alu_result_ready;

	fetch_stage0 fetch0(
		.clk(exec_if.clk),
		.reset_n(exec_if.reset_n),
		.pc(pc),
		.rd_ram_addr(exec_if.rd_ram_addr)
	);

	fetch_stage1 fetch1(
		.clk(exec_if.clk),
		.reset_n(exec_if.reset_n),
		.rd_ram_data(exec_if.rd_ram_data),
		.fetched_inst(fetched_inst)
	);

	decode_unit decode(
		.clk(exec_if.clk),
		.reset_n(exec_if.reset_n),
		.fetched_inst(fetched_inst),
		.reg_rd0_addr(decode_reg_rd0_addr),
		.reg_rd1_addr(decode_reg_rd1_addr),
		.reg_wr_addr(decode_reg_wr_addr),
		.reg_rd0_en(decode_reg_rd0_en),
		.reg_rd1_en(decode_reg_rd1_en),
		.reg_wr_en(decode_reg_wr_en),
		.input_a_is_immediate(decode_input_a_is_immediate),
		.inst_imm(decode_inst_imm),
		.alu_op(decode_alu_op)
	);

	alu_stage arithmetic_logic_unit(
		.clk(exec_if.clk),
		.reset_n(reset_n),
		.regfile_rd0_data(regfile_rd0_data),
		.regfile_rd1_data(regfile_rd1_data),
		.input_a_is_immediate(decode_input_a_is_immediate),
		.immediate(decode_inst_imm),
		.alu_op(decode_alu_op),
		.result_ready(alu_result_ready),
		.alu_result(alu_result)
	);
	assign reg_store_wr_addr = decode_reg_wr_addr;
	assign reg_store_wr_data = alu_result;
	assign reg_store_wr_en = decode_reg_wr_en;

endmodule


module register_store(
	input logic result_ready,
	input logic [31:0] alu_result,
	input logic decode_reg_wr_en,
	input logic [4:0] decode_reg_wr_addr,

	output logic [4:0] reg_wr_addr,
	output logic [31:0] reg_wr_data,
	output logic reg_wr_en
);

always @(result_ready) begin
	reg_wr_addr <= decode_reg_wr_addr;
	reg_wr_data <= alu_result;
	reg_wr_en <=  decode_reg_wr_en;
end

endmodule

