`ifndef __REGISTER_FILE_PROBE_IF_SV__
`define __REGISTER_FILE_PROBE_IF_SV__

`include "uvm_macros.svh"
import uvm_pkg::*;

interface register_file_probe_if(
	input logic clk,
	input logic [15:0] pc,
	input logic wr_en,
	input logic [4:0] wr_addr,
	input logic [31:0] wr_data);

	task wait_edge();
		@(clk iff(wr_en == 1));
	endtask : wait_edge

	function logic[36:0] get_value();
		return {>>{wr_addr, wr_data}};
	endfunction

endinterface

bind top.exec_core register_file_probe_if register_file_probe_inst(
	.clk(clk),
	.pc(ex_wb_r.pc),
	.wr_en(registers.wr_en),
	.wr_addr(registers.wr_addr),
	.wr_data(registers.wr_data)
);

module register_file_probe_wrapper(
  input logic clk
);
  initial begin
		uvm_config_db #(virtual register_file_probe_if)::set(null, "*", "register_file_probe_if", top.exec_core.register_file_probe_inst);
	end
endmodule

`endif
