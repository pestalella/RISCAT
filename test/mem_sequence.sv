`timescale 1ns / 1ns

class mem_sequence extends uvm_sequence #(mem_transaction);

	`uvm_object_utils(mem_sequence)

	function new (string name = "");
		super.new(name);
	endfunction

	task body;
		`uvm_info(get_type_name(), "Sequence start", UVM_MEDIUM)
		repeat(1000)
		begin
			`uvm_do(req)
		end
	endtask: body

endclass: mem_sequence
