`timescale 1ns / 1ns

class exec_core_scoreboard extends uvm_scoreboard;

  uvm_analysis_imp #(exec_core_transaction, exec_core_scoreboard) analysis_export;

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
    analysis_export = new("analysis_export", this);

	  transaction_count = 0;
		reset_count <= 0;
  endfunction

  function void write(input exec_core_transaction t);
    exec_core_transaction tx = exec_core_transaction::type_id::create("tx", this);
    tx.copy(t);
		transaction_count = transaction_count + 1;
		if (tx.cmd == CMD_RESET) begin
			reset_count += 1;
		end
  endfunction

endclass
