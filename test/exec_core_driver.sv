`include "../src/r32i_isa.svh"
`include "exec_core_action.sv"
`include "exec_unit_probe_if.sv"

class exec_core_driver extends uvm_driver #(exec_core_transaction);

	`uvm_component_utils(exec_core_driver)

	virtual exec_unit_probe_if vif;
	uvm_analysis_port #(exec_core_message) m_ap;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase in exec_core_driver", UVM_MEDIUM)
		if( !uvm_config_db #(virtual exec_unit_probe_if)::get(this, "", "exec_unit_probe_if", vif) )
			`uvm_error(get_type_name(), "uvm_config_db::get failed")
		m_ap = new("m_ap", this);
	endfunction

	task run_phase(uvm_phase phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			// `uvm_info(get_type_name(), $sformatf("\n%s", req.sprint()), UVM_MEDIUM)

			if (req.cmd == CMD_RESET)
			begin
				@(posedge vif.clk);
				vif.reset_n  <= 0;
				@(posedge vif.clk);
				vif.reset_n  <= 1;
			end else if (req.cmd == CMD_ADDI)
			begin
				exec_core_message action_received;
				reg_imm_instruction inst = new(ADDI);
				inst.randomize() with {src == 1; dest == 1;};

				// `uvm_info(get_type_name(), "GOT ADDI, WAITING FOR vif.rd_ram_en", UVM_MEDIUM)
				// `uvm_info(get_type_name(), $sformatf("Got vif.rd_ram_en, injecting ADDI instruction:\n%s", inst.sprint()), UVM_MEDIUM)
				vif.rd_ram_data <= inst.encoded();

				action_received = exec_core_message::type_id::create("action_received", this);
				action_received.imm = inst.imm;
				action_received.src = inst.src;
				action_received.dest = inst.dest;
				action_received.m_action = INST_ADDI;
				m_ap.write(action_received);

				@(posedge vif.clk);
			end	else begin
				`uvm_fatal(get_type_name(), "Unimplemented command in transaction")
			end
			seq_item_port.item_done();

		end
	endtask

	function bit[31:0] generate_instruction(instruction rv_inst);
		reg_imm_instruction inst = new(ADDI);
		`uvm_info(get_type_name(), $sformatf("Generated instruction: 0x%h", inst.encoded()), UVM_MEDIUM)
		return inst.encoded();
	endfunction
endclass: exec_core_driver
