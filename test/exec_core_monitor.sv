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
				tx.action  = RESET;
				m_ap.write(tx);
			end else begin
				if (execunit_vif.is_jump) begin
					`uvm_info(get_type_name(), $sformatf("Detected a jump from PC=%1d to PC=%1d",
						execunit_vif.pc, execunit_vif.pc + signed'({execunit_vif.jump_offset, 1'b0})), UVM_MEDIUM);

					tx = exec_core_message::type_id::create("tx", this);
					tx.action  = JUMP;
					tx.pc = execunit_vif.pc;
					tx.rd = execunit_vif.id_ex_r.reg_wr_addr;
					tx.reg_wr_data = execunit_vif.id_ex_r.jump_return_addr;
					tx.jump_offset = execunit_vif.jump_offset;
					m_ap.write(tx);
				end

				if (regfile_vif.wr_en) begin
					`uvm_info(
						get_type_name(),
						$sformatf("Detected a register file write. r%1d = %1d",	regfile_vif.wr_addr, signed'(regfile_vif.wr_data)),
						UVM_MEDIUM
					);

					tx = exec_core_message::type_id::create("tx", this);
					tx.action  = REG_WR;
					tx.pc = regfile_vif.pc;
					tx.rd = regfile_vif.wr_addr;
					tx.reg_wr_data = regfile_vif.wr_data;
					m_ap.write(tx);
				end

				if (!execunit_vif.id_ex_r.do_not_execute) begin
					// Some instruction. If it's an ALU instruction, report it
					if (execunit_vif.id_ex_r.alu_op != ALU_NONE && !execunit_vif.is_jump)
					begin
						`uvm_info(get_type_name(), $sformatf("Detected an ALU instruction: %s",
							execunit_vif.id_ex_r.alu_op.name()), UVM_MEDIUM)

						tx = exec_core_message::type_id::create("tx", this);
						tx.action = aluop_to_action(execunit_vif.id_ex_r.alu_op);
						tx.pc = execunit_vif.id_ex_r.pc;
						tx.imm = execunit_vif.id_ex_r.inst_imm;
						tx.rs1 = execunit_vif.id_ex_r.rs1_addr;
						tx.rs2 = execunit_vif.id_ex_r.rs2_addr;
						tx.rd = execunit_vif.id_ex_r.reg_wr_addr;
						tx.shamt = execunit_vif.id_ex_r.shamt;
						m_ap.write(tx);
					end
				end
			end
		end
	endtask

	function exec_core_action aluop_to_action(alu_command_t alu_op);
		if (alu_op == ALU_ADDI) return INST_ADDI;
		if (alu_op == ALU_SLTI) return INST_SLTI;
		if (alu_op == ALU_SLTIU) return INST_SLTIU;
		if (alu_op == ALU_SLLI) return INST_SLLI;
		if (alu_op == ALU_SRLI) return INST_SRLI;
		if (alu_op == ALU_SRAI) return INST_SRAI;
		if (alu_op == ALU_XORI) return INST_XORI;
		if (alu_op == ALU_ORI) return INST_ORI;
		if (alu_op == ALU_ANDI) return INST_ANDI;
		if (alu_op == ALU_ADD) return INST_ADD;
		if (alu_op == ALU_SUB) return INST_SUB;
		if (alu_op == ALU_SLL) return INST_SLL;
		if (alu_op == ALU_SLT) return INST_SLT;
		if (alu_op == ALU_SLTU) return INST_SLTU;
		if (alu_op == ALU_XOR) return INST_XOR;
		if (alu_op == ALU_SRL) return INST_SRL;
		if (alu_op == ALU_SRA) return INST_SRA;
		if (alu_op == ALU_OR) return INST_OR;
		if (alu_op == ALU_AND) return INST_AND;
		if (alu_op == ALU_JAL) return INST_JAL;
		`uvm_fatal(get_type_name(), "unknown ALU OP. Can't generate  an action")
	endfunction

endclass: exec_core_monitor

