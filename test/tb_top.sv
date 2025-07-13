`ifndef __TB_TOP_SV__
`define __TB_TOP_SV__

`timescale 1ns / 1ns

`include "uvm_macros.svh"
`include "exec_core_tests.sv"
`include "register_file_probe_if.sv"
`include "../src/execution_unit.sv"
`include "../src/memsys.sv"
`include "../src/r32i_isa.svh"

import uvm_pkg::*;

class random_inst_generator;
	rand instruction instr;

	constraint few_jumps {
		instr dist {
			ADDI	:= 100,
			SLTI 	:= 100,
			SLTIU := 100,
			XORI	:= 100,
			ORI		:= 100,
			ANDI 	:= 100,
			SLLI 	:= 100,
			SRLI 	:= 100,
			SRAI 	:= 100,
			ADD 	:= 100,
			SUB 	:= 100,
			SLL 	:= 100,
			SLT		:= 100,
			SLTU 	:= 100,
			XOR 	:= 100,
			SRL 	:= 100,
			SRA 	:= 100,
			OR 		:= 100,
			AND 	:= 100,
			JAL 	:= 1
		};
	}

	function bit[31:0] gen();
			case(instr)
					ADDI,	SLTI,	SLTIU,	XORI,	ORI,	ANDI,	SLLI,	SRLI,	SRAI: begin
						reg_imm_inst inst_reg_imm;
						inst_reg_imm = new(instr);
						inst_reg_imm.randomize();
						return inst_reg_imm.encoded();
					end
					ADD,	SUB,	SLL,	SLT,	SLTU,	XOR,	SRL,	SRA,	OR,	AND: begin
						reg_reg_inst inst_reg_reg;
						inst_reg_reg = new(instr);
						inst_reg_reg.randomize();
						return inst_reg_reg.encoded();
					end
					JAL: begin
						jal_inst jump_inst;
						jump_inst = new(instr);
						jump_inst.randomize();
						return jump_inst.encoded();
					end
			endcase
	endfunction
endclass

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
		random_inst_generator rand_inst;
		// jal_inst jump_inst;
		// reg_imm_inst inst_reg_imm;

		`uvm_info("tb_top::init_memory", "Initializing program memory", UVM_MEDIUM)

		for (int i = 0; i < $size(instructions.data); i++) begin
			instructions.data[i] = '{default:0};
		end

		// [00] 		addi r27, r0, 1234
		// [04] 		jal r1, label1
		// [08] 		addi r15, r0, 777
		// [12] 			addi r0, r0, k0
		// [16] label3: addi r0, r0, 0
		// [20] label1: jal r1, label2
		// [24] 			addi r0, r0, 0
		// [28] 			addi r0, r0, 0
		// [32] 			addi r0, r0, 0
		// [36] 			addi r0, r0, 0
		// [40] 			addi r0, r0, 0
		// [44] 			addi r0, r0, 0
		// [48] 			addi r0, r0, 0
		// [52] label2: jal r1, label3(-36)

		// inst_reg_imm = new(ADDI);
		// inst_reg_imm.imm = 1234;
		// inst_reg_imm.rs1 = 0;
		// inst_reg_imm.rd = 27;
		// instructions.data[0] = inst_reg_imm.encoded();

		// jump_inst = new(JAL);
		// jump_inst.jump_offset = 16;
		// jump_inst.rd = 1;

		// instructions.data[4] = jump_inst.encoded();

		// inst_reg_imm = new(ADDI);
		// inst_reg_imm.imm = 777;
		// inst_reg_imm.rs1 = 0;
		// inst_reg_imm.rd = 15;
		// instructions.data[8] = inst_reg_imm.encoded();

		// jump_inst.jump_offset = 32;
		// instructions.data[20] = jump_inst.encoded();
		// jump_inst.jump_offset = -36;
		// instructions.data[52] = jump_inst.encoded();

		rand_inst = new();
		for (int i = 0; i < $size(instructions.data); i++) begin
			rand_inst.randomize();// with { instr != JAL; };
			instructions.data[i] = rand_inst.gen();
		end


	endtask

endmodule: top

`endif
