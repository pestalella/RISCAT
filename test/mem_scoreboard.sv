`timescale 1ns / 1ns

class mem_scoreboard extends uvm_scoreboard;

  uvm_analysis_imp #(mem_transaction, mem_scoreboard) analysis_export;

	logic [7:0] expected_memory [3:0];

	int transaction_count;
	int read_count;
	int write_count;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

	`uvm_component_utils_begin(mem_scoreboard)
		`uvm_field_int(transaction_count, UVM_DEFAULT|UVM_DEC)
		`uvm_field_int(read_count, UVM_DEFAULT|UVM_DEC)
		`uvm_field_int(write_count, UVM_DEFAULT|UVM_DEC)
	`uvm_object_utils_end

  function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
    analysis_export = new("analysis_export", this);

	  transaction_count = 0;
	  read_count = 0;
	  write_count = 0;
  endfunction

  function void write(input mem_transaction t);
    mem_transaction tx = mem_transaction::type_id::create("tx", this);
    tx.copy(t);
		transaction_count = transaction_count + 1;
		if (tx.cmd == WRITE) begin
			write_count = write_count + 1;
			updateScoreboard(tx);
		end	else begin
			read_count = read_count + 1;
			checkScoreboard(tx);
		end
  endfunction

  function void updateScoreboard(input mem_transaction t);
		expected_memory[t.addr] = t.data;
  endfunction

  function void checkScoreboard(input mem_transaction t);
		if (expected_memory[t.addr] != t.data)
			`uvm_error(get_type_name(),
				$sformatf("Read unexpected value from dut: expected %h at address %h but got %h",
					expected_memory[t.addr], t.addr, t.data) )
  endfunction


endclass
