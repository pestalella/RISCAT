
	class registerfile_test extends uvm_test;

		`uvm_component_utils(registerfile_test)

		registerfile_env m_env;

		function new(string name, uvm_component parent);
			super.new(name, parent);
			`uvm_info(get_type_name(), "new reg test", UVM_MEDIUM)
		endfunction

		function void build_phase(uvm_phase phase);
			m_env = registerfile_env::type_id::create("m_env", this);
		endfunction

	endclass: registerfile_test
