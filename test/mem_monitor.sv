
class mem_monitor extends uvm_monitor;

	`uvm_component_utils(mem_monitor)

	virtual memsys_if vif;
	uvm_analysis_port #(mem_transaction) m_ap;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
		m_ap = new("m_ap", this);
		if( !uvm_config_db #(virtual memsys_if)::get(this, "", "memsys_if", vif) )
			`uvm_error(get_type_name(), "uvm_config_db::get failed")
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "run_phase", UVM_MEDIUM)
		forever
		begin
			mem_transaction tx;
			@(posedge vif.clk);
			if (vif.rd_en) begin
				tx = mem_transaction::type_id::create("tx", this);
				tx.cmd  = READ;
				tx.addr = vif.rd_addr;
				tx.data = vif.rd_data;
				m_ap.write(tx);
			end else if (vif.wr_en) begin
				tx = mem_transaction::type_id::create("tx", this);
				tx.cmd  = WRITE;
				tx.addr = vif.wr_addr;
				tx.data = vif.wr_data;
				m_ap.write(tx);
			end
		end
	endtask

endclass: mem_monitor

