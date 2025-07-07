`include "../src/r32i_isa.svh"
`include "exec_core_message.sv"
`include "exec_unit_probe_if.sv"

`define IF_CREATE_INSTRUCTION_ELSE(result, inst_name) \
	if (req.cmd == CMD_``inst_name) 				  \
	begin										 	  \
		``result = new(``inst_name);			 		  \
		action_received.action = INST_``inst_name;  \
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
//				vif.rd_ram_data <= '{default:0};
				@(posedge vif.clk);  // wait a clock cycle to stabilize signals
			end else if (req.cmd == CMD_JAL) begin
				jal_inst jump_inst;
				exec_core_message action_received  = exec_core_message::type_id::create("action_received", this);

				jump_inst = new(JAL);
				jump_inst.jump_offset = req.jump_offset;
				jump_inst.rd = req.rd;

//				vif.rd_ram_data <= jump_inst.encoded();
				@(posedge vif.clk);

				`uvm_info(get_type_name(), $sformatf("[%04h]: %s", vif.rd_ram_addr, jump_inst.sprint()), UVM_MEDIUM)

				action_received.action = INST_JAL;
				action_received.rd = req.rd;
				action_received.jump_offset = req.jump_offset;
				m_ap.write(action_received);
			end else begin
				exec_core_message action_received  = exec_core_message::type_id::create("action_received", this);

				if (req.is_reg_imm) begin
					reg_imm_inst inst_reg_imm;

					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, ADDI)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, SLTI)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, SLTIU)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, SLLI)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, SRLI)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, SRAI)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, XORI)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, ORI)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_imm, ANDI)
					begin
						`uvm_error(get_type_name(), $sformatf("UNSUPPORTED REQUEST:%s", req.sprint()))
					end
					inst_reg_imm.imm = req.imm;
					inst_reg_imm.rs1 = req.rs1;
					inst_reg_imm.rd = req.rd;
					inst_reg_imm.shamt = req.shamt;

//					vif.rd_ram_data <= inst_reg_imm.encoded();
					@(posedge vif.clk);

					`uvm_info(get_type_name(), $sformatf("[%04h]: %s", vif.rd_ram_addr, inst_reg_imm.sprint()), UVM_MEDIUM)

					action_received.pc = vif.rd_ram_addr;
					action_received.imm = req.imm;
					action_received.rs1 = req.rs1;
					action_received.rd = req.rd;
					action_received.shamt = req.shamt;
					m_ap.write(action_received);
				end else if (req.is_reg_reg) begin
					reg_reg_inst inst_reg_reg;
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_reg, ADD)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_reg, SUB)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_reg, SLL)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_reg, SLT)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_reg, SLTU)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_reg, XOR)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_reg, SRL)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_reg, SRA)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_reg, OR)
					`IF_CREATE_INSTRUCTION_ELSE(inst_reg_reg, AND)
					begin
						`uvm_warning(get_type_name(), $sformatf("Unimplemented command in transaction:\n%s", req.sprint()))
					end

					inst_reg_reg.rs1 = req.rs1;
					inst_reg_reg.rs2 = req.rs2;
					inst_reg_reg.rd = req.rd;
//					vif.rd_ram_data <= inst_reg_reg.encoded();
					@(posedge vif.clk);

					`uvm_info(get_type_name(), $sformatf("[%04h]: %s", vif.rd_ram_addr, inst_reg_reg.sprint()), UVM_MEDIUM)

					action_received.pc = vif.rd_ram_addr;
					action_received.rs1 = req.rs1;
					action_received.rs2 = req.rs2;
					action_received.rd = req.rd;
					m_ap.write(action_received);

				end

			end
			seq_item_port.item_done();

		end
	endtask

	function bit[31:0] generate_instruction(instruction rv_inst);
		reg_imm_inst inst = new(ADDI);
		`uvm_info(get_type_name(), $sformatf("Generated instruction: 0x%h", inst.encoded()), UVM_MEDIUM)
		return inst.encoded();
	endfunction
endclass: exec_core_driver
