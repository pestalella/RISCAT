`ifndef __TB_TOP_SV__
`define __TB_TOP_SV__

`timescale 1ns / 1ns

`include "uvm_macros.svh"
`include "exec_core_tests.sv"
`include "register_file_probe_if.sv"
`include "../src/execution_unit.sv"
`include "../src/memsys.sv"

import uvm_pkg::*;

module top;

	import uvm_pkg::*;

	logic clk;
	logic reset_n;

	wire rd_mem_en;
	wire [15:0] rd_mem_addr;
	wire [31:0] rd_mem_data;

	wire wr_mem_en;
	wire [31:0] wr_mem_addr;
	wire [31:0] wr_mem_data;

	register_file_probe_wrapper probe_wrapper(.clk(clk));
	exec_unit_probe_wrapper exec_probe_wrapper(.clk(clk));

	read_only_memory#(.ADDR_BITS(16)) instructions(
		.clk(clk),

		.rd_en(rd_mem_en),
		.rd_addr(rd_mem_addr),
		.rd_data(rd_mem_data)
	);

	exec_unit exec_core(
		.clk(clk),
		.reset_n(reset_n),

		.rd_ram_en(rd_mem_en),
		.rd_ram_addr(rd_mem_addr),
		.rd_ram_data(rd_mem_data),

		.wr_ram_en(wr_mem_en),
		.wr_ram_addr(wr_mem_addr),
		.wr_ram_data(wr_mem_data)
	);

	initial
	begin
		reset_n = 0;
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial
	begin
		$timeformat(-9, 0, " ns", 5); //$timeformat( units_number , precision_number , suffix_string , minimum_field_width )
		//run_test("mem_test");
		//run_test("registerfile_test");
		init_memory();
		run_test("exec_core_reset");
	end

	task init_memory();
		jal_inst jump_inst;
		reg_imm_inst inst_reg_imm;

		`uvm_info("tb_top::init_memory", "Initializing program memory", UVM_MEDIUM)

		for (int i = 0; i < $size(instructions.data); i++) begin
			instructions.data[i] = '{default:0};
		end

		jump_inst = new(JAL);
		jump_inst.jump_offset = 16;
		jump_inst.rd = 1;

		instructions.data[0] = jump_inst.encoded();

		inst_reg_imm = new(ADDI);
		inst_reg_imm.imm = 1234;
		inst_reg_imm.rs1 = 0;
		inst_reg_imm.rd = 27;
		instructions.data[4] = inst_reg_imm.encoded();

		jump_inst.jump_offset = 32;
		instructions.data[16] = jump_inst.encoded();
		jump_inst.jump_offset = -40;
		instructions.data[48] = jump_inst.encoded();
	endtask

endmodule: top

`endif
