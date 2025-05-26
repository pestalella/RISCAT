`timescale 1ns / 1ns

class mem_agent extends uvm_agent;

	`uvm_component_utils(mem_agent)

	mem_sequencer m_sequencer;
	mem_driver    m_driver;
  mem_monitor   m_monitor;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
		if (get_is_active())
		begin
			m_sequencer = mem_sequencer::type_id::create("m_sequencer", this);
			m_driver    = mem_driver::type_id::create("m_driver", this);
		end
    m_monitor     = mem_monitor::type_id::create("m_monitor", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		if (get_is_active())
			m_driver.seq_item_port.connect( m_sequencer.seq_item_export );
	endfunction

endclass: mem_agent

