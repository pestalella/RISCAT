`ifndef __EXEC_CORE_ACTION_SV__
`define __EXEC_CORE_ACTION_SV__


typedef enum {RESET, INST_ADDI, REG_WR} exec_core_action;

`include "uvm_macros.svh"

import uvm_pkg::*;

class exec_core_message extends uvm_sequence_item;

	exec_core_action m_action;
	bit[31:0] pc;
	bit[11:0] imm;
	bit[4:0] src;
	bit[4:0] dest;
	bit[31:0] reg_wr_data;

	function new (string name = "");
		super.new(name);
	endfunction

	function string to_asm_string();
		return $sformatf("r%1d = r%1d + %1d", dest, src, imm);
	endfunction

	`uvm_object_utils_begin(exec_core_message)
		`uvm_field_enum(exec_core_action, m_action, UVM_DEFAULT)
		`uvm_field_int(pc, UVM_DEFAULT|UVM_HEX)
		`uvm_field_int(imm, UVM_DEFAULT|UVM_HEX)
		`uvm_field_int(src, UVM_DEFAULT)
		`uvm_field_int(dest, UVM_DEFAULT)
		`uvm_field_int(reg_wr_data, UVM_DEFAULT|UVM_HEX)
	`uvm_object_utils_end

endclass: exec_core_message

`endif
