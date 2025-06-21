typedef enum {
	CMD_RESET,
	CMD_ADDI,
	CMD_SLTI,
	CMD_SLTIU,
	CMD_XORI,
	CMD_ORI,
	CMD_ANDI,
	CMD_ADD,
	CMD_SUB,
	CMD_SLL,
	CMD_SLT,
	CMD_SLTU,
	CMD_XOR,
	CMD_SRL,
	CMD_SRA,
	CMD_OR,
	CMD_AND
} exec_core_cmd;

`include "uvm_macros.svh"

import uvm_pkg::*;

class exec_core_transaction extends uvm_sequence_item;

	rand exec_core_cmd cmd;
	rand bit[4:0] rs1;
	rand bit[4:0] rs2;
	rand bit[4:0] dst;
	rand bit[11:0] imm;

	function new (string name = "");
		super.new(name);
	endfunction

	`uvm_object_utils_begin(exec_core_transaction)
		`uvm_field_enum(exec_core_cmd, cmd, UVM_DEFAULT)
	`uvm_object_utils_end

endclass: exec_core_transaction

typedef uvm_sequencer #(exec_core_transaction) exec_core_sequencer;

