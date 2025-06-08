`include "exec_unit_probe_if.sv"

class exec_core_monitor extends uvm_monitor;

	`uvm_component_utils(exec_core_monitor)

	virtual exec_unit_probe_if execunit_vif;
	virtual register_file_probe_if regfile_vif;

	uvm_analysis_port #(exec_core_message) m_ap;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
		m_ap = new("m_ap", this);
		if( !uvm_config_db #(virtual exec_unit_probe_if)::get(this, "", "exec_unit_probe_if", execunit_vif) )
		 	`uvm_error(get_type_name(), "No exec_unit_probe_if found in uvm_config_db")
		if( !uvm_config_db #(virtual register_file_probe_if)::get(this, "", "register_file_probe_if", regfile_vif) )
			`uvm_error(get_type_name(), "No register_file_probe_if found in uvm_config_db")
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "run_phase", UVM_MEDIUM)
		forever
		begin
			exec_core_message tx;
			@(posedge execunit_vif.clk);
			if (!execunit_vif.reset_n) begin
				`uvm_info(get_type_name(), "Detected a reset", UVM_MEDIUM);
				tx = exec_core_message::type_id::create("tx", this);
				tx.m_action  = RESET;
				m_ap.write(tx);
			end else if (regfile_vif.wr_en) begin
				`uvm_info(get_type_name(), $sformatf("Detected a register file write. r%1d = %1h", regfile_vif.wr_addr, regfile_vif.wr_data), UVM_MEDIUM);
				tx = exec_core_message::type_id::create("tx", this);
				tx.m_action  = REG_WR;
				tx.dest = regfile_vif.wr_addr;
				tx.reg_wr_data = regfile_vif.wr_data;
				m_ap.write(tx);
			end
			// 	tx = exec_core_transaction::type_id::create("tx", this);
			// 	tx.cmd  = READ_MEM;
			// 	tx.rd0_addr = vif.rd0_addr;
			// 	tx.rd0_data = vif.rd0_data;
			// 	m_ap.write(tx);
			// end
			// else if (!vif.rd0_en && vif.rd1_en) begin
			// 	tx = exec_core_transaction::type_id::create("tx", this);
			// 	tx.cmd  = READB;
			// 	tx.rd1_addr = vif.rd1_addr;k
			// 	tx.rd1_data = vif.rd1_data;
			// 	m_ap.write(tx);
			// end
			// else if (vif.rd0_en && vif.rd1_en) begin
			// 	tx = exec_core_transaction::type_id::create("tx", this);
			// 	tx.cmd  = READAB;
			// 	tx.rd0_addr = vif.rd0_addr;
			// 	tx.rd0_data = vif.rd0_data;
			// 	tx.rd1_addr = vif.rd1_addr;
			// 	tx.rd1_data = vif.rd1_data;
			// 	m_ap.write(tx);
			// end
			// else if (vif.wr_en) begin
			// 	tx = exec_core_transaction::type_id::create("tx", this);
			// 	tx.cmd  = WRITE;
			// 	tx.wr_addr = vif.wr_addr;
			// 	tx.wr_data = vif.wr_data;
			// 	m_ap.write(tx);
			// end
		end
	endtask

endclass: exec_core_monitor

