`timescale 1ns / 1ns

class registerfile_monitor extends uvm_monitor;

	`uvm_component_utils(registerfile_monitor)

	virtual regfile_if vif;
	uvm_analysis_port #(registerfile_transaction) m_ap;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
		m_ap = new("m_ap", this);
		if (!uvm_config_db #(virtual regfile_if)::get(this, "", "regfile_if", vif))
			`uvm_error(get_type_name(), "uvm_config_db::get failed")
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "run_phase", UVM_MEDIUM)
		forever
		begin
			registerfile_transaction tx;
			@(posedge vif.clk);
			if (!vif.reset_n) begin
				tx = registerfile_transaction::type_id::create("tx", this);
				tx.cmd  = RESET;
				m_ap.write(tx);
			end
			else if (vif.rd0_en && !vif.rd1_en) begin
				tx = registerfile_transaction::type_id::create("tx", this);
				tx.cmd  = READA;
				tx.rd0_addr = vif.rd0_addr;
				tx.rd0_data = vif.rd0_data;
				m_ap.write(tx);
			end
			else if (!vif.rd0_en && vif.rd1_en) begin
				tx = registerfile_transaction::type_id::create("tx", this);
				tx.cmd  = READB;
				tx.rd1_addr = vif.rd1_addr;
				tx.rd1_data = vif.rd1_data;
				m_ap.write(tx);
			end
			else if (vif.rd0_en && vif.rd1_en) begin
				tx = registerfile_transaction::type_id::create("tx", this);
				tx.cmd  = READAB;
				tx.rd0_addr = vif.rd0_addr;
				tx.rd0_data = vif.rd0_data;
				tx.rd1_addr = vif.rd1_addr;
				tx.rd1_data = vif.rd1_data;
				m_ap.write(tx);
			end
			else if (vif.wr_en) begin
				tx = registerfile_transaction::type_id::create("tx", this);
				tx.cmd  = WRITE;
				tx.wr_addr = vif.wr_addr;
				tx.wr_data = vif.wr_data;
				m_ap.write(tx);
			end
		end
	endtask

endclass: registerfile_monitor

