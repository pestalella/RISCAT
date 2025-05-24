`timescale 1ns / 1ps

class registerfile_driver extends uvm_driver #(registerfile_transaction);

	`uvm_component_utils(registerfile_driver)

	virtual regfile_if vif;

  logic [4:0] m_wr_addr;
  logic [31:0] m_wr_data;
	logic [4:0] m_r0_addr;
	logic [31:0] m_r0_data;
	logic [4:0] m_r1_addr;
	logic [31:0] m_r1_data;

  covergroup cg_driver_received_transaction;
    coverpoint m_wr_addr {
      option.at_least = 1;
    }
    coverpoint m_wr_data {
			bins range0_1GB_lo   = {[32'h00000000:32'h07FFFFFF]};
			bins range0_1GB_hi   = {[32'h08000000:32'h0FFFFFFF]};
			bins range1GB_2GB_lo = {[32'h10000000:32'h17FFFFFF]};
			bins range1GB_2GB_hi = {[32'h18000000:32'h1FFFFFFF]};
			bins range2GB_3GB_lo = {[32'h20000000:32'h27FFFFFF]};
			bins range2GB_3GB_hi = {[32'h28000000:32'h2FFFFFFF]};
			bins range3GB_4GB_lo = {[32'h30000000:32'h37FFFFFF]};
			bins range3GB_4GB_hi = {[32'h38000000:32'h3FFFFFFF]};
      option.at_least = 1;
    }

    coverpoint m_r0_addr {
      option.at_least = 1;
    }
    coverpoint m_r0_data {
			bins range0_1GB_lo   = {[32'h00000000:32'h07FFFFFF]};
			bins range0_1GB_hi   = {[32'h08000000:32'h0FFFFFFF]};
			bins range1GB_2GB_lo = {[32'h10000000:32'h17FFFFFF]};
			bins range1GB_2GB_hi = {[32'h18000000:32'h1FFFFFFF]};
			bins range2GB_3GB_lo = {[32'h20000000:32'h27FFFFFF]};
			bins range2GB_3GB_hi = {[32'h28000000:32'h2FFFFFFF]};
			bins range3GB_4GB_lo = {[32'h30000000:32'h37FFFFFF]};
			bins range3GB_4GB_hi = {[32'h38000000:32'h3FFFFFFF]};
      option.at_least = 1;
    }

    coverpoint m_r1_addr {
      option.at_least = 1;
    }
    coverpoint m_r1_data {
			bins range0_1GB_lo   = {[32'h00000000:32'h07FFFFFF]};
			bins range0_1GB_hi   = {[32'h08000000:32'h0FFFFFFF]};
			bins range1GB_2GB_lo = {[32'h10000000:32'h17FFFFFF]};
			bins range1GB_2GB_hi = {[32'h18000000:32'h1FFFFFFF]};
			bins range2GB_3GB_lo = {[32'h20000000:32'h27FFFFFF]};
			bins range2GB_3GB_hi = {[32'h28000000:32'h2FFFFFFF]};
			bins range3GB_4GB_lo = {[32'h30000000:32'h37FFFFFF]};
			bins range3GB_4GB_hi = {[32'h38000000:32'h3FFFFFFF]};
      option.at_least = 1;
    }
  endgroup

	function new(string name, uvm_component parent);
		super.new(name, parent);

		cg_driver_received_transaction = new;

	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "build_phase in registerfile_driver", UVM_MEDIUM)
		if( !uvm_config_db #(virtual regfile_if)::get(this, "", "regfile_if", vif) )
			`uvm_error(get_type_name(), "uvm_config_db::get failed")
	endfunction

	task run_phase(uvm_phase phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			//`uvm_info(get_type_name(), req.sprint(), UVM_MEDIUM)

			if (req.cmd == RESET)
			begin
				vif.reset_n  <= 0;
				@(posedge vif.clk);
				vif.reset_n  <= 1;
				@(posedge vif.clk);
			end
			else if (req.cmd == WRITE)
			begin
				m_wr_addr = req.wr_addr;
				m_wr_data = req.wr_data;

				vif.wr_en   <= 1;
				vif.rd0_en   <= 0;
				vif.rd1_en   <= 0;
				vif.wr_addr <= req.wr_addr;
				vif.wr_data <= req.wr_data;
				@(posedge vif.clk);
				vif.wr_en   <= 0;
				@(posedge vif.clk);
			end
			else if (req.cmd == READA)
			begin
				m_r0_addr = req.rd0_addr;
				m_r0_data = req.rd0_data;

				vif.wr_en     <= 0;
				vif.rd0_en    <= 1;
				vif.rd1_en    <= 0;
				vif.rd0_addr  <= req.rd0_addr;
				@(posedge vif.clk);
				vif.rd0_en     <= 0;
				@(posedge vif.clk);
				req.rd0_data     = vif.rd0_data;
			end
			else if (req.cmd == READB)
			begin
				m_r1_addr = req.rd1_addr;
				m_r1_data = req.rd1_data;

				vif.wr_en     <= 0;
				vif.rd0_en    <= 0;
				vif.rd1_en    <= 1;
				vif.rd1_addr  <= req.rd1_addr;
				@(posedge vif.clk);
				vif.rd1_en     <= 0;
				@(posedge vif.clk);
				req.rd1_data     = vif.rd1_data;
			end
			else if (req.cmd == READAB)
			begin
				m_r0_addr = req.rd0_addr;
				m_r0_data = req.rd0_data;
				m_r1_addr = req.rd1_addr;
				m_r1_data = req.rd1_data;

				vif.wr_en     <= 0;
				vif.rd0_en    <= 1;
				vif.rd1_en    <= 1;
				vif.rd0_addr  <= req.rd0_addr;
				vif.rd1_addr  <= req.rd1_addr;
				@(posedge vif.clk);
				vif.rd0_en     <= 0;
				vif.rd1_en     <= 0;
				@(posedge vif.clk);
				req.rd0_data     = vif.rd0_data;
				req.rd1_data     = vif.rd1_data;
			end
			cg_driver_received_transaction.sample();

			seq_item_port.item_done();
		end
	endtask
endclass: registerfile_driver
