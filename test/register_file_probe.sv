`ifndef __REGISTER_FILE_PROBE_SV__
`define __REGISTER_FILE_PROBE_SV__

`include "uvm_macros.svh"
import uvm_pkg::*;

class register_file_probe extends uvm_component;
	`uvm_component_utils(register_file_probe)

	register_file_probe_config m_reg_probe_config;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (m_reg_probe_config == null) begin
			if (!uvm_config_db #(register_file_probe_config)::get(this, "", "m_reg_probe_config", m_reg_probe_config)) begin
				`uvm_fatal(get_full_name(), "No register_file_probe config found in the config db!")
			end
		end
	endfunction : build_phase
endclass : register_file_probe

`endif
