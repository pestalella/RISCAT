`include "../src/r32i_isa.svh"
`include "exec_core_action.sv"
`include "exec_unit_probe_if.sv"

`define IF_CREATE_INSTRUCTION_ELSE(result, inst_name)   \
	if (req.cmd == CMD_``inst_name) 							 \
	begin										 								 \
		`result = new(``inst_name);			 							 \
		action_received.m_action = INST_``inst_name; \
	end else

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
				vif.rd_ram_data <= '{default:0};
				@(posedge vif.clk);  // wait a clock cycle to stabilize signals
			end else begin
				exec_core_message action_received  = exec_core_message::type_id::create("action_received", this);
				reg_imm_instruction inst_reg_imm;
				reg_imm_instruction inst;

				`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, ADDI)
				`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, SLTI)
				`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, SLTIU)
				`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, XORI)
				`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, ORI)
				`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, ANDI)
				`IF_CREATE_INSTRUCTION_ELSE(ADD)
				`IF_CREATE_INSTRUCTION_ELSE(SUB)
				`IF_CREATE_INSTRUCTION_ELSE(SLL)
				`IF_CREATE_INSTRUCTION_ELSE(SLT)
				`IF_CREATE_INSTRUCTION_ELSE(SLTU)
				`IF_CREATE_INSTRUCTION_ELSE(XOR)
				`IF_CREATE_INSTRUCTION_ELSE(SRL)
				`IF_CREATE_INSTRUCTION_ELSE(SRA)
				`IF_CREATE_INSTRUCTION_ELSE(OR)
				`IF_CREATE_INSTRUCTION_ELSE(AND)
				begin
					`uvm_warning(get_type_name(), $sformatf("Unimplemented command in transaction:\n%s", req.sprint()))
				end

				// if (req.cmd == CMD_ADDI)
				// begin
				// 	inst = new(ADDI);
				// 	action_received.m_action = INST_ADDI;
				// end else if (req.cmd == CMD_SLTI)
				// begin
				// 	inst = new(SLTI);
				// 	action_received.m_action = INST_SLTI;
				// end else if (req.cmd == CMD_SLTIU)
				// begin
				// 	inst = new(SLTIU);
				// 	action_received.m_action = INST_SLTIU;
				// end else if (req.cmd == CMD_ANDI)
				// begin
				// 	inst = new(ANDI);
				// 	action_received.m_action = INST_ANDI;
				// end else if (req.cmd == CMD_XORI)
				// begin
				// 	inst = new(XORI);
				// 	action_received.m_action = INST_XORI;
				// end else if (req.cmd == CMD_ADD)
				// begin
				// 	inst = new(ADD);
				// 	action_received.m_action = INST_ADD;

				// end else if (req.cmd == CMD_SUB)
				// begin
				// 	inst = new(SUB);
				// 	action_received.m_action = INST_SUB;
				// end else if (req.cmd == CMD_SLL)
				// begin
				// 	inst = new(SLL);
				// 	action_received.m_action = INST_SLL;
				// end else if (req.cmd == CMD_SLT)
				// begin
				// 	inst = new(SLT);
				// 	action_received.m_action = INST_SLT;
				// end else if (req.cmd == CMD_SLTU)
				// begin
				// 	inst = new(SLTU);
				// 	action_received.m_action = INST_SLTU;
				// end else if (req.cmd == CMD_XOR)
				// begin
				// 	inst = new(XOR);
				// 	action_received.m_action = INST_XOR;
				// end else if (req.cmd == CMD_SRL)
				// begin
				// 	inst = new(SRL);
				// 	action_received.m_action = INST_SRL;
				// end else if (req.cmd == CMD_ORI)
				// begin
				// 	inst = new(ORI);
				// 	action_received.m_action = INST_ORI;
				// end else if (req.cmd == CMD_ORI)
				// begin
				// 	inst = new(ORI);
				// 	action_received.m_action = INST_ORI;
				// end else if (req.cmd == CMD_ORI)
				// begin
				// 	inst = new(ORI);
				// 	action_received.m_action = INST_ORI;
				// end else if (req.cmd == CMD_ORI)
				// begin
				// 	inst = new(ORI);
				// 	action_received.m_action = INST_ORI;
				// end else
				// begin
				// 	`uvm_warning(get_type_name(), $sformatf("Unimplemented command in transaction:\n%s", req.sprint()))
				// end

				inst.imm = req.imm;
				inst.src = req.rs1;
				inst.dst = req.dst;
				vif.rd_ram_data <= inst.encoded();

				@(posedge vif.clk);

				`uvm_info(get_type_name(), $sformatf("[%04h]: %s", vif.rd_ram_addr, inst.sprint()), UVM_MEDIUM)

				action_received.pc = vif.rd_ram_addr;
				action_received.imm = req.imm;
				action_received.rs1 = req.rs1;
				action_received.dest = req.dst;
				m_ap.write(action_received);
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
