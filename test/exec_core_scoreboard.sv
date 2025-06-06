
class exec_core_scoreboard extends uvm_scoreboard;

	uvm_analysis_imp #(exec_core_message, exec_core_scoreboard) m_ap;

	exec_core_message transactions[$];

	bit [31:0] regfile_copy [4:0];
	bit [31:0] expected_reg_inputs [4:0];

	`uvm_component_utils_begin(exec_core_scoreboard)
		// `uvm_field_int(transaction_count, UVM_DEFAULT|UVM_DEC)
		// `uvm_field_int(reset_count, UVM_DEFAULT|UVM_DEC)
	`uvm_object_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
    m_ap = new("m_ap", this);
  endfunction

  virtual function void write(input exec_core_message t);
    exec_core_message tx = exec_core_message::type_id::create("tx", this);
    tx.copy(t);
		if (tx.m_action == RESET) begin
			`uvm_info(get_type_name(), $sformatf("received a RESET action:\n%s", tx.sprint()), UVM_MEDIUM)
			regfile_copy = '{default:0};
			expected_reg_inputs = '{default:0};
			transactions.delete();

		end else if (tx.m_action == INST_ADDI) begin
			`uvm_info(get_type_name(), $sformatf("received a ADDI action:\n%s", tx.sprint()), UVM_MEDIUM)
			tx.reg_wr_data = expected_reg_inputs[tx.src] + tx.imm;
			expected_reg_inputs[tx.src] = tx.reg_wr_data;
			transactions.push_back(tx);  // saved for later check
			`uvm_info(get_type_name(), $sformatf("stored transactions: %d", transactions.size()), UVM_MEDIUM)


		end else if (tx.m_action == REG_WR) begin
			exec_core_message saved_transaction = transactions.pop_front();
			`uvm_info(get_type_name(), $sformatf("received a RegisterWrite action:\n%s\nsaved_transaciont:\n%s\n", tx.sprint(), saved_transaction.sprint()), UVM_MEDIUM)
			if (tx.dest == 0) begin
				`uvm_info(get_type_name, "Ignoring write to r0", UVM_MEDIUM)
			end else begin
				assert (tx.dest == saved_transaction.dest) else
					`uvm_fatal(get_type_name(),
						$sformatf("received a write to r%1d, was expecting a write to r%1d", tx.dest, saved_transaction.dest))

				assert (tx.reg_wr_data == saved_transaction.reg_wr_data)
					regfile_copy[tx.dest] = saved_transaction.reg_wr_data;
				else
					`uvm_error(get_type_name(),
						$sformatf("received a write to r%1d, expected value was %0h, received %0h instead",
							tx.dest, saved_transaction.reg_wr_data, tx.reg_wr_data))
			end
		end
  endfunction

endclass

