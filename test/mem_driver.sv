`timescale 1ns / 1ps

class mem_driver extends uvm_driver #(mem_transaction);

	`uvm_component_utils(mem_driver)

	virtual memsys_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase in mem_driver", UVM_MEDIUM)
		if( !uvm_config_db #(virtual memsys_if)::get(this, "", "memsys_if", vif) )
			`uvm_error(get_type_name(), "uvm_config_db::get failed")
	endfunction

	task run_phase(uvm_phase phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			//`uvm_info(get_type_name(), req.sprint(), UVM_MEDIUM)

			if (req.cmd == WRITE)
				begin
					vif.wr_en   <= 1;
					vif.rd_en   <= 0;
					vif.wr_addr <= req.addr;
					vif.wr_data <= req.data;
					@(posedge vif.clk);
					vif.wr_en   <= 0;
					@(posedge vif.clk);
				end
			else
				begin
					vif.wr_en     <= 0;
					vif.rd_en     <= 1;
					vif.rd_addr    <= req.addr;
					@(posedge vif.clk);
					vif.rd_en     <= 0;
					@(posedge vif.clk);
					req.data     = vif.rd_data;
				end

			seq_item_port.item_done();
		end
	endtask
endclass: mem_driver
