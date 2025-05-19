
class registerfile_sequence extends uvm_sequence #(registerfile_transaction);

	`uvm_object_utils(registerfile_sequence)

	function new (string name = "");
		super.new(name);
	endfunction

	task body;
		`uvm_info(get_type_name(), "Sequence start", UVM_MEDIUM)
		repeat(100000)
		begin
			`uvm_do(req)
		end
	endtask: body

endclass: registerfile_sequence
