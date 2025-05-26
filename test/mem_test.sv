`timescale 1ns / 1ns

class mem_test extends uvm_test;

	`uvm_component_utils(mem_test)

	mem_env m_env;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		`uvm_info(get_type_name(), "new memtest", UVM_MEDIUM)
	endfunction

	function void build_phase(uvm_phase phase);
		m_env = mem_env::type_id::create("m_env", this);
	endfunction

endclass: mem_test
