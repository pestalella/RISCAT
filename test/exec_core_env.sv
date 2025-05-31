`ifndef __EXEC_CORE_ENV__
`define __EXEC_CORE_ENV__

`include "uvm_macros.svh"
`include "register_file_probe_config.sv"
`include "exec_core_agent.sv"
`include "exec_core_scoreboard.sv"
`include "register_file_probe.sv"
`include "exec_core_sequence.sv"

import uvm_pkg::*;

class exec_core_env extends uvm_env;

	`uvm_component_utils(exec_core_env)

	exec_core_agent m_agent;
	exec_core_scoreboard m_scoreboard;
	register_file_probe m_reg_probe_inst;
	register_file_probe_config m_reg_probe_config;
	virtual register_file_probe_if m_reg_probe_if;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
		m_agent = exec_core_agent::type_id::create("m_agent", this);
		m_scoreboard = exec_core_scoreboard::type_id::create("m_scoreboard", this);
		m_reg_probe_inst = register_file_probe::type_id::create("m_reg_probe_inst", this);
		m_reg_probe_config = register_file_probe_config::type_id::create("m_reg_probe_config");
		if (!uvm_config_db #(virtual register_file_probe_if)::get(this, "", "register_file_probe_if", m_reg_probe_if)) begin
			`uvm_fatal(get_full_name(), "No register_file_probe interface found in the config db!")
		end
	  m_reg_probe_config.set_interface(m_reg_probe_if);
		uvm_config_db #(register_file_probe_config)::set(null, "*", "m_reg_probe_config", m_reg_probe_config);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		m_agent.m_monitor.m_ap.connect(m_scoreboard.analysis_export);
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
		exec_core_sequence seq;
		seq = exec_core_sequence::type_id::create("seq");
		`uvm_info(get_type_name(), "run_phase: created sequence", UVM_MEDIUM)
		if (!seq.randomize()) begin
			`uvm_error(get_type_name(), "Randomize failed")
		end

		seq.set_starting_phase(phase);
		seq.set_automatic_phase_objection(1);
		seq.start( m_agent.m_sequencer );
		`uvm_info(get_type_name(), $sformatf("Results:\n%s", m_scoreboard.sprint()), UVM_MEDIUM)
	endtask : run_phase

endclass: exec_core_env

`endif
