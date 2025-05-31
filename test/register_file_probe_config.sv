`ifndef __REGISTER_FILE_PROBE_CONFIG_SV__
`define __REGISTER_FILE_PROBE_CONFIG_SV__

`include "uvm_macros.svh"
import uvm_pkg::*;

class register_file_probe_config extends uvm_object;

	`uvm_object_utils(register_file_probe_config)

	string interface_name;
	virtual register_file_probe_if vif;

	function new(string name = "");
		super.new(name);
	endfunction

	function automatic void set_interface(virtual register_file_probe_if iface);
		vif = iface;
	endfunction

endclass : register_file_probe_config

`endif
