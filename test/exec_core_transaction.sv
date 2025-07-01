typedef enum {
	CMD_RESET,
	// ALU instructions
	CMD_ADDI,
	CMD_SLTI,
	CMD_SLTIU,
	CMD_XORI,
	CMD_ORI,
	CMD_ANDI,
	CMD_SLLI,
	CMD_SRLI,
	CMD_SRAI,
	CMD_ADD,
	CMD_SUB,
	CMD_SLL,
	CMD_SLT,
	CMD_SLTU,
	CMD_XOR,
	CMD_SRL,
	CMD_SRA,
	CMD_OR,
	CMD_AND,
	// Jumps
	CMD_JAL
} exec_core_cmd;

`include "uvm_macros.svh"

import uvm_pkg::*;

class 	exec_core_transaction extends uvm_sequence_item;

	rand exec_core_cmd cmd;
	bit is_reg_imm;
	bit is_reg_reg;
	rand bit[4:0] rs1;
	rand bit[4:0] rs2;
	rand bit[4:0] rd;
	rand bit[11:0] imm;
	rand bit[20:0] jump_offset;
	rand bit [4:0] shamt;

	function new (string name = "");
		super.new(name);
	endfunction

	function void post_randomize();
		is_reg_imm = 0;
		is_reg_reg = 0;
		case (cmd) inside
			CMD_ADDI, CMD_SLTI, CMD_SLTIU, CMD_XORI, CMD_ORI, CMD_ANDI, CMD_SLLI, CMD_SRLI, CMD_SRAI: is_reg_imm = 1; 
			CMD_ADD, CMD_SUB, CMD_SLL, CMD_SLT, CMD_SLTU, CMD_XOR, CMD_SRL, CMD_SRA, CMD_OR, CMD_AND: is_reg_reg = 1; 
		endcase
	endfunction

	`uvm_object_utils_begin(exec_core_transaction)
		`uvm_field_enum(exec_core_cmd, cmd, UVM_DEFAULT)
	`uvm_object_utils_end

endclass: exec_core_transaction

typedef uvm_sequencer #(exec_core_transaction) exec_core_sequencer;

