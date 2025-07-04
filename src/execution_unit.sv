
`include "alu_enums.svh"
`include "register32bit_file.sv"
`include "fetch_unit.sv"
`include "decode_unit.sv"
`include "writeback_unit.sv"
`include "alu.sv"
`include "pipeline_stage_registers.sv"


module exec_unit (
	input logic clk,
	output logic reset_n,

	output wire rd_ram_en,
	output logic [15:0] rd_ram_addr,
	input logic [31:0] rd_ram_data,

	output wire wr_ram_en,
	output logic [31:0] wr_ram_addr,
	input logic [31:0] wr_ram_data
);

	logic [15:0] pc;
	logic jump_was_fetched;

	// Don't read while we inject a bubble
	assign rd_ram_en = 1;
//	assign rd_ram_en = ~jump_was_fetched;

	// Update program counter
	always_ff @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			pc  <= 0;
		end else if (id_ex_reg.is_jump) begin
			pc <= id_ex_reg.pc + id_ex_reg.jump_offset;
		end	else if (!jump_was_fetched) begin
			pc  <= pc + 4;
		end
	end

	IF_ID if_id_reg;
	ID_EX id_ex_reg;
	EX_WB ex_wb_reg;

	logic wb_wr_en;
	logic [4:0] wb_wr_addr;
	logic [31:0] wb_wr_data;

	logic [31:0] regfile_rs1;
	logic [31:0] regfile_rs2;

	logic raw_hazard_rs1;
	logic raw_hazard_rs2;

	assert property(@(posedge clk) !$isunknown(id_ex_reg));

	fetch_unit instruction_fetch(
		.clk(clk),
		.reset_n(reset_n),
		.pc(pc),
		.rd_ram_data(rd_ram_data),
		.jump_was_fetched(jump_was_fetched),
		.rd_ram_addr(rd_ram_addr),
		.if_id_reg(if_id_reg)
	);

	always_ff @(posedge clk) begin
		raw_hazard_rs1 <= ((if_id_reg.fetched_inst[11:7] != 0) && (id_ex_reg.reg_wr_addr != 0) && (id_ex_reg.reg_wr_addr == if_id_reg.fetched_inst[19:15]));
		raw_hazard_rs2 <= ((if_id_reg.fetched_inst[11:7] != 0) && (id_ex_reg.reg_wr_addr != 0) && (id_ex_reg.reg_wr_addr == if_id_reg.fetched_inst[24:20]));
	end

	decode_unit instruction_decode(
		.clk(clk),
		.reset_n(reset_n),
		.if_id_reg(if_id_reg),
		.id_ex_reg(id_ex_reg)
	);

	register32bit_file registers(
		.clk(clk),
		.reset_n(reset_n),
		.rd0_en(id_ex_reg.reg_rs1_en),
		.rd0_addr(id_ex_reg.reg_rs1_addr),
		.rd0_data(regfile_rs1),
		.rd1_en(id_ex_reg.reg_rs2_en),
		.rd1_addr(id_ex_reg.reg_rs2_addr),
		.rd1_data(regfile_rs2),
		.wr_en(wb_wr_en),
		.wr_addr(wb_wr_addr),
		.wr_data(wb_wr_data)
	);

	wire [31:0] alu_reg_input_a;
	wire [31:0] alu_reg_input_b;

	assign alu_reg_input_a = raw_hazard_rs1? ex_wb_reg.alu_result : regfile_rs1;
	assign alu_reg_input_b = raw_hazard_rs2? ex_wb_reg.alu_result : regfile_rs2;

	alu_stage arithmetic_logic_unit(
		.clk(clk),
		.reset_n(reset_n),
		.id_ex_reg(id_ex_reg),
		.alu_reg_input_a(alu_reg_input_a),
		.alu_reg_input_b(alu_reg_input_b),
		.ex_wb_reg(ex_wb_reg)
	);

	writeback_unit wb_stage(
		.clk(clk),
		.reset_n(reset_n),
		.result_ready(ex_wb_reg.alu_result_ready),
		.alu_result(ex_wb_reg.alu_result),
		.wr_addr(ex_wb_reg.reg_wr_addr),

		.reg_wr_en(wb_wr_en),
		.reg_wr_addr(wb_wr_addr),
		.reg_wr_data(wb_wr_data)
	);

endmodule

