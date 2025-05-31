

class registerfile_scoreboard extends uvm_scoreboard;

  uvm_analysis_imp #(registerfile_transaction, registerfile_scoreboard) analysis_export;

	logic [31:0] expected_registerfile [4:0];

	int transaction_count;
	int read_count;
	int write_count;
	int reset_count;

  logic [4:0] m_wr_addr;
  logic [31:0] m_wr_data;
	logic [4:0] m_r0_addr;
	logic [31:0] m_r0_data;
	logic [4:0] m_r1_addr;
	logic [31:0] m_r1_data;

  covergroup cg;
    coverpoint m_wr_addr {
      option.at_least = 1;
    }
    coverpoint m_wr_data {
			bins range0_1GB_lo   = {[32'h00000000:32'h07FFFFFF]};
			bins range0_1GB_hi   = {[32'h08000000:32'h0FFFFFFF]};
			bins range1GB_2GB_lo = {[32'h10000000:32'h17FFFFFF]};
			bins range1GB_2GB_hi = {[32'h18000000:32'h1FFFFFFF]};
			bins range2GB_3GB_lo = {[32'h20000000:32'h27FFFFFF]};
			bins range2GB_3GB_hi = {[32'h28000000:32'h2FFFFFFF]};
			bins range3GB_4GB_lo = {[32'h30000000:32'h37FFFFFF]};
			bins range3GB_4GB_hi = {[32'h38000000:32'h3FFFFFFF]};
      option.at_least = 1;
    }

    coverpoint m_r0_addr {
      option.at_least = 1;
    }
    coverpoint m_r0_data {
			bins range0_1GB_lo   = {[32'h00000000:32'h07FFFFFF]};
			bins range0_1GB_hi   = {[32'h08000000:32'h0FFFFFFF]};
			bins range1GB_2GB_lo = {[32'h10000000:32'h17FFFFFF]};
			bins range1GB_2GB_hi = {[32'h18000000:32'h1FFFFFFF]};
			bins range2GB_3GB_lo = {[32'h20000000:32'h27FFFFFF]};
			bins range2GB_3GB_hi = {[32'h28000000:32'h2FFFFFFF]};
			bins range3GB_4GB_lo = {[32'h30000000:32'h37FFFFFF]};
			bins range3GB_4GB_hi = {[32'h38000000:32'h3FFFFFFF]};
      option.at_least = 1;
    }

    coverpoint m_r1_addr {
      option.at_least = 1;
    }
    coverpoint m_r1_data {
			bins range0_1GB_lo   = {[32'h00000000:32'h07FFFFFF]};
			bins range0_1GB_hi   = {[32'h08000000:32'h0FFFFFFF]};
			bins range1GB_2GB_lo = {[32'h10000000:32'h17FFFFFF]};
			bins range1GB_2GB_hi = {[32'h18000000:32'h1FFFFFFF]};
			bins range2GB_3GB_lo = {[32'h20000000:32'h27FFFFFF]};
			bins range2GB_3GB_hi = {[32'h28000000:32'h2FFFFFFF]};
			bins range3GB_4GB_lo = {[32'h30000000:32'h37FFFFFF]};
			bins range3GB_4GB_hi = {[32'h38000000:32'h3FFFFFFF]};
      option.at_least = 1;
    }
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg = new;
  endfunction

	`uvm_component_utils_begin(registerfile_scoreboard)
		`uvm_field_int(transaction_count, UVM_DEFAULT|UVM_DEC)
		`uvm_field_int(read_count, UVM_DEFAULT|UVM_DEC)
		`uvm_field_int(write_count, UVM_DEFAULT|UVM_DEC)
		`uvm_field_int(reset_count, UVM_DEFAULT|UVM_DEC)
	`uvm_object_utils_end

  function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
    analysis_export = new("analysis_export", this);
		expected_registerfile <= '{default: '0};

	  transaction_count = 0;
	  read_count <= 0;
	  write_count <= 0;
		reset_count <= 0;
  endfunction

  function void write(input registerfile_transaction t);
    registerfile_transaction tx = registerfile_transaction::type_id::create("tx", this);
    tx.copy(t);
		transaction_count = transaction_count + 1;
		if (tx.cmd == RESET) begin
			reset_count += 1;
			resetExpectedFile(tx);
		end
		else if (tx.cmd == WRITE) begin
			write_count = write_count + 1;
			updateExpectedFile(tx);
			cg.sample();
		end
		else if (tx.cmd == READA) begin
			m_r0_addr = t.rd0_addr;
			m_r0_data = t.rd0_data;
			if (m_r0_addr != 0) cg.sample();

			read_count = read_count + 1;
			checkOneRead(tx.rd0_addr, tx.rd0_data);
		end
		else if (tx.cmd == READB) begin
			m_r1_addr = t.rd1_addr;
			m_r1_data = t.rd1_data;
			if (m_r1_addr != 0) cg.sample();

			read_count = read_count + 1;
			checkOneRead(tx.rd1_addr, tx.rd1_data);
		end
		else if (tx.cmd == READAB) begin
			m_r0_addr = t.rd0_addr;
			m_r0_data = t.rd0_data;
			m_r1_addr = t.rd1_addr;
			m_r1_data = t.rd1_data;

			read_count = read_count + 1;
			checkOneRead(tx.rd0_addr, tx.rd0_data);
			checkOneRead(tx.rd1_addr, tx.rd1_data);
		end
  endfunction

  function void resetExpectedFile(input registerfile_transaction t);
		expected_registerfile <= '{default: '0};
  endfunction

  function void updateExpectedFile(input registerfile_transaction t);
		if (t.wr_addr != 0)
			expected_registerfile[t.wr_addr] <= t.wr_data;
		// For coverage sampling purposes
		m_wr_addr = t.wr_addr;
		m_wr_data = t.wr_data;
  endfunction

  function void checkOneRead(bit[4:0] addr, bit[31:0] data);
		if (expected_registerfile[addr] != data)
			`uvm_error(get_type_name(),
				$sformatf("Read unexpected value from dut: expected %h at address %h but got %h",
					expected_registerfile[addr], addr, data) )
  endfunction


endclass
