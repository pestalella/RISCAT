`ifndef __EXEC_CORE_SEQUENCE_SV__
`define __EXEC_CORE_SEQUENCE_SV__

class exec_core_sequence extends uvm_sequence #(exec_core_transaction);

	`uvm_object_utils(exec_core_sequence)

	function new (string name = "");
		super.new(name);
	endfunction

	task body;

		`uvm_info(get_type_name(), "Sequence start", UVM_MEDIUM)
		// Perform an initial RESET to clean up the cpu state
		`uvm_do_with(req, { req.cmd == CMD_RESET; })
		// `uvm_do_with(req, {
		// 	req.cmd == CMD_ADDI;
		// 	req.src_reg })
		repeat(4)
		begin
			`uvm_do_with(req, { req.cmd == CMD_ADDI; })
		end
		`uvm_do_with(req, { req.cmd == CMD_RESET; })

		repeat(4)
		begin
			`uvm_do_with(req, { req.cmd == CMD_ADDI; })
		end
		`uvm_do_with(req, { req.cmd == CMD_RESET; })

		repeat(4)
		begin
			`uvm_do_with(req, { req.cmd == CMD_ADDI; })
		end
		`uvm_do_with(req, { req.cmd == CMD_RESET; })
	endtask: body

endclass: exec_core_sequence

`endif
