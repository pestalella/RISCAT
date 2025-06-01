
class exec_core_scoreboard extends uvm_scoreboard;

	uvm_analysis_imp #(exec_core_action, exec_core_scoreboard) m_ap;

	int transaction_count;
	int reset_count;

	`uvm_component_utils_begin(exec_core_scoreboard)
		`uvm_field_int(transaction_count, UVM_DEFAULT|UVM_DEC)
		`uvm_field_int(reset_count, UVM_DEFAULT|UVM_DEC)
	`uvm_object_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
    m_ap = new("m_ap", this);

	  transaction_count = 0;
		reset_count <= 0;
  endfunction

  virtual function void write(input exec_core_action t);
    exec_core_action tx = exec_core_action::type_id::create("tx", this);
    tx.copy(t);
		if (tx.m_inst_name == INST_ADDI) begin
			`uvm_info(get_type_name(), "received a ADDI action", UVM_MEDIUM)
		end
  endfunction

endclass
