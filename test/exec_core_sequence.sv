
class exec_core_sequence extends uvm_sequence #(exec_core_transaction);

	`uvm_object_utils(exec_core_sequence)

	function new (string name = "");
		super.new(name);
	endfunction

	task body;
		`uvm_info(get_type_name(), "Sequence start", UVM_MEDIUM)
		repeat(2)
		begin
			`uvm_do(req)
		end
	endtask: body

endclass: exec_core_sequence
