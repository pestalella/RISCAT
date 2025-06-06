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

		repeat(100)
		begin
			if ($urandom_range(100) < 99) begin
				`uvm_do_with(req, { req.cmd == CMD_ADDI; })
			end else begin
				`uvm_do_with(req, { req.cmd == CMD_RESET; })
			end
		end
	endtask: body

endclass: exec_core_sequence

`endif
