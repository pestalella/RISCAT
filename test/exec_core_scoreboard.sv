
class exec_core_scoreboard extends uvm_scoreboard;

	uvm_analysis_imp #(exec_core_message, exec_core_scoreboard) m_ap;

	exec_core_message transactions[$];
	bit[15:0] expected_jumps[$];
	bit[31:0] expected_reg_inputs [0:31];

	int instruction_count;

	`uvm_component_utils_begin(exec_core_scoreboard)
		`uvm_field_int(instruction_count, UVM_DEFAULT|UVM_DEC)
		// `uvm_field_int(reset_count, UVM_DEFAULT|UVM_DEC)
	`uvm_object_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
    m_ap = new("m_ap", this);
		instruction_count = 0;
  endfunction

  virtual function void write(input exec_core_message t);
    exec_core_message tx = exec_core_message::type_id::create("tx", this);
		`uvm_info(get_type_name(), $sformatf("Pending regwrites:%1d Received exec_core_message:\n%s", transactions.size(), t.sprint()), UVM_MEDIUM)
    tx.copy(t);
		if (tx.action == RESET) begin
			// `uvm_info(get_type_name(), $sformatf("received a RESET action:\n%s", tx.sprint()), UVM_MEDIUM)
			expected_reg_inputs = '{default:0};
			transactions.delete();
			expected_jumps.delete();
		end	else begin
			if (tx.action == REG_WR) begin
				exec_core_message saved_transaction;
				assert (transactions.size() != 0) else
					`uvm_fatal(get_type_name(), "No saved register writes!")
				saved_transaction = transactions.pop_front();
				`uvm_info(get_type_name, $sformatf("Popped transaction:\n%s", saved_transaction.sprint()), UVM_DEBUG)
				if (tx.rd == 0) begin
					`uvm_info(get_type_name(), "Ignoring write to r0", UVM_MEDIUM)
				end else begin
					assert (tx.rd == saved_transaction.rd) else
						`uvm_fatal(get_type_name(),
							$sformatf("received a write to r%1d, was expecting a write to r%1d", tx.rd, saved_transaction.rd))
					assert (signed'(tx.reg_wr_data) == signed'(saved_transaction.reg_wr_data))
					else
						`uvm_error(get_type_name(),
							$sformatf("received a write to r%1d, expected value was %1d, received %1d instead.\nReceived transaction:\n%sSaved transaction:\n%s",
								tx.rd, signed'(saved_transaction.reg_wr_data), signed'(tx.reg_wr_data), tx.sprint(), saved_transaction.sprint()))
				end
			end else begin
				instruction_count = instruction_count + 1;
				if (tx.action == JUMP) begin
					bit[15:0] target = tx.pc +  signed'(tx.jump_offset);
					`uvm_info(get_type_name(), $sformatf("A jump to address %1d will happen soon", target), UVM_MEDIUM)
					// expected_jumps.push_back(target);
					if (tx.rd != 0) begin
							expected_reg_inputs[tx.rd] = tx.reg_wr_data;
							`uvm_info(get_type_name(), $sformatf("r%1d =%1d",	tx.rd, signed'(expected_reg_inputs[tx.rd])), UVM_MEDIUM)
					end
				end	else if (tx.action == INST_ADDI) begin
					tx.reg_wr_data = signed'(expected_reg_inputs[tx.rs1]) + signed'({{20{tx.imm[11]}}, tx.imm[11:0]});
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d)+%1d",
							tx.rd, signed'(expected_reg_inputs[tx.rd]), tx.rs1, signed'(expected_reg_inputs[tx.rs1]), signed'({{20{tx.imm[11]}}, tx.imm[11:0]})), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SLTI) begin
					tx.reg_wr_data = signed'(expected_reg_inputs[tx.rs1]) < signed'({{20{tx.imm[11]}}, tx.imm[11:0]}) ? 1 : 0;
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d) < %1d",
							tx.rd, signed'(expected_reg_inputs[tx.rd]), tx.rs1, signed'(expected_reg_inputs[tx.rs1]), signed'({{20{tx.imm[11]}}, tx.imm[11:0]})), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SLTIU) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] < {{20{tx.imm[11]}}, tx.imm[11:0]} ? 1 : 0;
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d) < %1d",
							tx.rd, signed'(expected_reg_inputs[tx.rd]), tx.rs1, expected_reg_inputs[tx.rs1], {{20{tx.imm[11]}}, tx.imm[11:0]}), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_ANDI) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] & {{20{tx.imm[11]}}, tx.imm[11:0]};
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1b) = r%1d(=%1b) & %1b",
							tx.rd, signed'(expected_reg_inputs[tx.rd]), tx.rs1, expected_reg_inputs[tx.rs1], {{20{tx.imm[11]}}, tx.imm[11:0]}), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_XORI) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] ^ {{20{tx.imm[11]}}, tx.imm[11:0]};
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1b) = r%1d(=%1b) ^ %1b",
							tx.rd, signed'(expected_reg_inputs[tx.rd]), tx.rs1, expected_reg_inputs[tx.rs1], {{20{tx.imm[11]}}, tx.imm[11:0]}), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_ORI) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] | {{20{tx.imm[11]}}, tx.imm[11:0]};
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1b) = r%1d(=%1b) | %1b",
							tx.rd, signed'(expected_reg_inputs[tx.rd]), tx.rs1, expected_reg_inputs[tx.rs1], {{20{tx.imm[11]}}, tx.imm[11:0]}), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_ADD) begin
					tx.reg_wr_data = signed'(expected_reg_inputs[tx.rs1]) + signed'(expected_reg_inputs[tx.rs2]);
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d)+r%1d(=%1d)",
							tx.rd, signed'(expected_reg_inputs[tx.rd]),
							tx.rs1, signed'(expected_reg_inputs[tx.rs1]),
							tx.rs2, signed'(expected_reg_inputs[tx.rs2])), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SUB) begin
					tx.reg_wr_data = signed'(expected_reg_inputs[tx.rs1]) - signed'(expected_reg_inputs[tx.rs2]);
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d)-r%1d(=%1d)",
							tx.rd, signed'(expected_reg_inputs[tx.rd]),
							tx.rs1, signed'(expected_reg_inputs[tx.rs1]),
							tx.rs2, signed'(expected_reg_inputs[tx.rs2])), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SLT) begin
					tx.reg_wr_data = (signed'(expected_reg_inputs[tx.rs1]) < signed'(expected_reg_inputs[tx.rs2]))? 1 : 0;
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d) < r%1d(=%1d)",
							tx.rd, expected_reg_inputs[tx.rd],
							tx.rs1, signed'(expected_reg_inputs[tx.rs1]),
							tx.rs2, signed'(expected_reg_inputs[tx.rs2])), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SLTU) begin
					tx.reg_wr_data = (expected_reg_inputs[tx.rs1] < expected_reg_inputs[tx.rs2])? 1 : 0;
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d) < r%1d(=%1d)",
							tx.rd, expected_reg_inputs[tx.rd],
							tx.rs1, expected_reg_inputs[tx.rs1],
							tx.rs2, expected_reg_inputs[tx.rs2]), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SLL) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] << expected_reg_inputs[tx.rs2][4:0];
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d) << r%1d(=%1d)",
							tx.rd, expected_reg_inputs[tx.rd],
							tx.rs1, expected_reg_inputs[tx.rs1],
							tx.rs2, expected_reg_inputs[tx.rs2][4:0]), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SRL) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] >> expected_reg_inputs[tx.rs2][4:0];
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d) >> r%1d(=%1d)",
							tx.rd, expected_reg_inputs[tx.rd],
							tx.rs1, expected_reg_inputs[tx.rs1],
							tx.rs2, expected_reg_inputs[tx.rs2][4:0]), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SRA) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] >>> expected_reg_inputs[tx.rs2][4:0];
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d) >>> r%1d(=%1d)",
							tx.rd, expected_reg_inputs[tx.rd],
							tx.rs1, expected_reg_inputs[tx.rs1],
							tx.rs2, expected_reg_inputs[tx.rs2][4:0]), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SLLI) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] << tx.shamt;
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d) << %1d",
							tx.rd, expected_reg_inputs[tx.rd],
							tx.rs1, expected_reg_inputs[tx.rs1],
							tx.shamt), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SRLI) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] >> tx.shamt;
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d) >> %1d",
							tx.rd, expected_reg_inputs[tx.rd],
							tx.rs1, expected_reg_inputs[tx.rs1],
							tx.shamt), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_SRAI) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] >>> tx.shamt;
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1d) = r%1d(=%1d) >>> %1d",
							tx.rd, expected_reg_inputs[tx.rd],
							tx.rs1, expected_reg_inputs[tx.rs1],
							tx.shamt), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_AND) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] & expected_reg_inputs[tx.rs2];
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1b) = r%1d(=%1b) & r%1d(%1b)",
							tx.rd, signed'(expected_reg_inputs[tx.rd]), tx.rs1, expected_reg_inputs[tx.rs1],
							tx.rs2, expected_reg_inputs[tx.rs2]), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_XOR) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] ^ expected_reg_inputs[tx.rs2];
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1b) = r%1d(=%1b) ^ r%1d(%1b)",
							tx.rd, signed'(expected_reg_inputs[tx.rd]), tx.rs1, expected_reg_inputs[tx.rs1],
							tx.rs2, expected_reg_inputs[tx.rs2]), UVM_MEDIUM)
					end
				end
				else if (tx.action == INST_OR) begin
					tx.reg_wr_data = expected_reg_inputs[tx.rs1] | expected_reg_inputs[tx.rs2];
					if (tx.rd != 0) begin
						`uvm_info(get_type_name(), $sformatf("r%1d(=%1b) = r%1d(=%1b) | r%1d(%1b)",
							tx.rd, signed'(expected_reg_inputs[tx.rd]), tx.rs1, expected_reg_inputs[tx.rs1],
							tx.rs2, expected_reg_inputs[tx.rs2]), UVM_MEDIUM)
					end
				end
				if (tx.rd != 0) begin
						expected_reg_inputs[tx.rd] = tx.reg_wr_data;
						`uvm_info(get_type_name(), $sformatf("r%1d =%1b",	tx.rd, signed'(expected_reg_inputs[tx.rd])), UVM_MEDIUM)
				end
				`uvm_info(get_type_name, $sformatf("Saving transaction:\n%s", tx.sprint()), UVM_MEDIUM)
				transactions.push_back(tx);  // saved for later check
			end
		end
	endfunction

endclass

