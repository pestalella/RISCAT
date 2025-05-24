`timescale 1ns / 1ps

`include "r32i_isa.svh"

class exec_core_driver extends uvm_driver #(exec_core_transaction);

	`uvm_component_utils(exec_core_driver)

	virtual exec_unit_if vif;

	logic reset_n;
  logic [4:0] m_wr_addr;
  logic [31:0] m_wr_data;
	logic [4:0] m_r0_addr;
	logic [31:0] m_r0_data;
	logic [4:0] m_r1_addr;
	logic [31:0] m_r1_data;

///	assign vif.reset_n = reset_n;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		reset_n = 1;
		`uvm_info(get_type_name(), "build_phase in exec_core_driver", UVM_MEDIUM)
		if( !uvm_config_db #(virtual exec_unit_if)::get(this, "", "exec_unit_if", vif) )
			`uvm_error(get_type_name(), "uvm_config_db::get failed")
	endfunction

	task run_phase(uvm_phase phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			`uvm_info(get_type_name(), req.sprint(), UVM_MEDIUM)

			if (req.cmd == CMD_RESET)
			begin
				@(posedge vif.clk);
				vif.reset_n  <= 0;
				@(posedge vif.clk);
				vif.reset_n  <= 1;
			end else if (req.cmd == CMD_ADDI)
			begin
				@(posedge vif.rd_ram_en);  // wait for the memory read request
				vif.rd_ram_data <= generate_instruction(ADDI);
				@(posedge vif.clk);
			end	else begin
				`uvm_fatal(get_type_name(), "Unimplemented command in transaction")
			end

			seq_item_port.item_done();
		end
	endtask

	function generate_instruction(exec_core_cmd cmd);
		reg_imm_instruction inst = new(ADDI);
		return inst.encoded();
	endfunction
endclass: exec_core_driver
