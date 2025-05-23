	class exec_core_env extends uvm_env;

		`uvm_component_utils(exec_core_env)

		exec_core_agent m_agent;
		exec_core_scoreboard m_scoreboard;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
			m_agent = exec_core_agent::type_id::create("m_agent", this);
			m_scoreboard = exec_core_scoreboard::type_id::create("m_scoreboard", this);
		endfunction

  function void connect_phase(uvm_phase phase);
    m_agent.m_monitor.m_ap.connect(m_scoreboard.analysis_export);
  endfunction

		task run_phase(uvm_phase phase);
			exec_core_sequence seq;
			seq = exec_core_sequence::type_id::create("seq");
			`uvm_info(get_type_name(), "run_phase: created sequence", UVM_MEDIUM)
			if( !seq.randomize() )
				`uvm_error(get_type_name(), "Randomize failed")

			seq.set_starting_phase(phase);
			seq.set_automatic_phase_objection(1);
			seq.start( m_agent.m_sequencer );
			`uvm_info(get_type_name(), $sformatf("Results:\n%s", m_scoreboard.sprint()), UVM_MEDIUM)
		endtask

	endclass: exec_core_env
