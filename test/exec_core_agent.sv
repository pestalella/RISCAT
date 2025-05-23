
`timescale 1ns / 1ps

class exec_core_agent extends uvm_agent;

	`uvm_component_utils(exec_core_agent)

	exec_core_sequencer m_sequencer;
	exec_core_driver    m_driver;
  exec_core_monitor   m_monitor;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
		if (get_is_active())
		begin
			m_sequencer = exec_core_sequencer::type_id::create("m_sequencer", this);
			m_driver    = exec_core_driver::type_id::create("m_driver", this);
		end
    m_monitor     = exec_core_monitor::type_id::create("m_monitor", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		if (get_is_active())
			m_driver.seq_item_port.connect( m_sequencer.seq_item_export );
	endfunction

endclass: exec_core_agent

