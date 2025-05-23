`timescale 1ns / 1ps

typedef enum {CMD_RESET, CMD_ADDI} exec_core_cmd;

class exec_core_transaction extends uvm_sequence_item;

	rand exec_core_cmd cmd;
	rand bit[4:0] src_reg;
	rand bit[4:0] dst_reg;
	rand bit[11:0] immediate;

	function new (string name = "");
		super.new(name);
	endfunction

	`uvm_object_utils_begin(exec_core_transaction)
		`uvm_field_enum(exec_core_cmd, cmd, UVM_DEFAULT)
		`uvm_field_int(src_reg, UVM_DEFAULT)
		`uvm_field_int(dst_reg, UVM_DEFAULT)
		`uvm_field_int(immediate, UVM_DEFAULT)
	`uvm_object_utils_end

endclass: exec_core_transaction
