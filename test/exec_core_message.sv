`ifndef __EXEC_CORE_ACTION_SV__
`define __EXEC_CORE_ACTION_SV__


typedef enum {
	RESET,
	REG_WR,
	// ALU instructions
	INST_ADDI,
	INST_SLLI,
	INST_SRLI,
	INST_SRAI,
	INST_SLTI,
	INST_SLTIU,
	INST_XORI,
	INST_ORI,
	INST_ANDI,
	INST_ADD,
	INST_SUB,
	INST_SLL,
	INST_SLT,
	INST_SLTU,
	INST_XOR,
	INST_SRL,
	INST_SRA,
	INST_OR,
	INST_AND,
	// Unconditional jumps
	INST_JAL,
	// Observed jump
	JUMP
} exec_core_action;

`include "uvm_macros.svh"

import uvm_pkg::*;

class exec_core_message extends uvm_sequence_item;

	exec_core_action m_action;
	bit[15:0] pc;
	bit[11:0] imm;
	bit[4:0] rs1;
	bit[4:0] rs2;
	bit[4:0] rd;
	bit[4:0] shamt;
	bit[31:0] reg_wr_data;
	bit[20:1] jump_offset;

	function new (string name = "");
		super.new(name);
	endfunction

	`uvm_object_utils_begin(exec_core_message)
		`uvm_field_enum(exec_core_action, m_action, UVM_DEFAULT)
		`uvm_field_int(pc, UVM_DEFAULT|UVM_HEX)
		`uvm_field_int(imm, UVM_DEFAULT|UVM_HEX)
		`uvm_field_int(rs1, UVM_DEFAULT)
		`uvm_field_int(rs2, UVM_DEFAULT)
		`uvm_field_int(rd, UVM_DEFAULT)
		`uvm_field_int(shamt, UVM_DEFAULT)
		`uvm_field_int(reg_wr_data, UVM_DEFAULT|UVM_HEX)
		`uvm_field_int(jump_offset, UVM_DEFAULT)
	`uvm_object_utils_end

endclass: exec_core_message

`endif
