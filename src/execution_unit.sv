`timescale 1ns / 1ns

`include "alu_enums.svh"

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
	//logic [4:0] reg_rd0_addr;
	//logic [4:0] reg_rd1_addr;
	//logic [4:0] reg_wr_addr;
	//logic reg_rd0_en;
	//logic reg_rd1_en;
	//logic reg_wr_en;

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

	logic rd_mem_en;

	assign exec_if.rd_ram_en = rd_mem_en;

	regfile_if regfile_interface();

	assign regfile_interface.clk = exec_if.clk;
	assign regfile_interface.reset_n = exec_if.reset_n;
	assign regfile_interface.rd0_en = decode_reg_rd0_en;
	assign regfile_interface.rd0_addr = decode_reg_rd0_addr;
	assign regfile_rd0_data = regfile_interface.rd0_data;
	assign regfile_interface.rd1_en = decode_reg_rd1_en;
	assign regfile_interface.rd1_addr = decode_reg_rd1_addr;
	assign regfile_rd1_data = regfile_interface.rd1_data;
	assign regfile_interface.wr_en = decode_reg_wr_en;
	assign regfile_interface.wr_addr = decode_reg_wr_addr;
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
		end
	end

	logic fetch_en;
	logic fetch_started;
	logic fetch_completed;
	wire [31:0] fetched_inst;
	logic alu_result_ready;

	initial begin
		fetch_en <= 1;
		rd_mem_en <= 0;
	end

	fetch_stage0 fetch0(
		.clk(exec_if.clk),
		.reset_n(exec_if.reset_n),
		.fetch_en(fetch_en),
		.fetch_started(fetch_started),
		.pc(pc),
		.rd_ram_en(rd_mem_en),
		.rd_ram_addr(exec_if.rd_ram_addr)
	);

	fetch_stage1 fetch1(
		.clk(exec_if.clk),
		.reset_n(exec_if.reset_n),
		.fetch_en(fetch_en),
		.fetch_started(fetch_started),
		.fetch_completed(fetch_completed),
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

endmodule


module fetch_stage0(
	input logic clk,
	input logic reset_n,
	input logic fetch_en,
	input logic [31:0] pc,

	output logic fetch_started,
	output logic rd_ram_en,
	output logic [31:0] rd_ram_addr
	);

	always @(posedge clk) begin
		if (!reset_n) begin
				rd_ram_en <= 0;
				fetch_started <= 0;
		end else begin
			if (fetch_en) begin
				rd_ram_addr <= pc;
				rd_ram_en <= 1;
				fetch_started <= 1;
			end else begin
				rd_ram_en <= 0;
				fetch_started <= 0;
			end
		end
	end

endmodule


module fetch_stage1(
	input logic clk,
	input logic reset_n,
	input logic fetch_started,
	input logic [31:0] rd_ram_data,

	output logic fetch_en,
	output logic fetch_completed,
	output logic [31:0] fetched_inst
	);

	logic [31:0] fetched_inst_r;
	assign fetched_inst = fetched_inst_r;

	always @(posedge clk) begin
		if (!reset_n) begin
				fetched_inst_r <= 0;
				fetch_completed <= 0;
		end else begin
			if (fetch_started) begin
				fetched_inst_r <= rd_ram_data;
				fetch_completed <= 1;
				fetch_en <= 0;
			end else begin
				fetch_completed <= 0;
			end
		end
	end

endmodule

module alu_stage(
	input logic clk,
	input logic reset_n,
	input logic [11:0] immediate,
	input logic [31:0] regfile_rd0_data,
	input logic [31:0] regfile_rd1_data,
	input logic input_a_is_immediate,
	input alu_command_t alu_op,
	output bit result_ready,
	output logic [31:0] alu_result
);

	always @(posedge clk) begin
		if (!reset_n) begin
			alu_result <= '0;
			result_ready <= 0;
		end else begin
			if (alu_op == ALU_NONE) begin
				alu_result <= '0;
				result_ready <= 0;
			end else if (alu_op == ALU_ADD) begin
				alu_result <=  input_a_is_immediate? immediate + regfile_rd1_data : 0;
				result_ready <= 1;
			end else begin
				alu_result <= 'hdeadbeef;
				result_ready <= 0;
			end
		end
	end


endmodule
