typedef enum {RESET} regfile_cmd;

class exec_core_transaction extends uvm_sequence_item;

	rand regfile_cmd cmd;

	function new (string name = "");
		super.new(name);
	endfunction

	`uvm_object_utils_begin(exec_core_transaction)
		`uvm_field_enum(regfile_cmd, cmd, UVM_DEFAULT)

	`uvm_object_utils_end

endclass: exec_core_transaction
