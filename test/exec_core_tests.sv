`ifndef __EXEC_CORE_TESTS_SV__
`define __EXEC_CORE_TESTS_SV__

`include "exec_core_env.sv"

`include "uvm_macros.svh"
import uvm_pkg::*;

class exec_core_reset extends uvm_test;

	`uvm_component_utils(exec_core_reset)

	exec_core_env m_env;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		`uvm_info(get_type_name(), "Reset execcore test", UVM_MEDIUM)
	endfunction

	function void build_phase(uvm_phase phase);
		m_env = exec_core_env::type_id::create("m_env", this);
	endfunction

endclass: exec_core_reset

`endif
