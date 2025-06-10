`ifndef __EXEC_UNIT_PROBE_IF_SV__
`define __EXEC_UNIT_PROBE_IF_SV__

`include "uvm_macros.svh"
import uvm_pkg::*;

interface exec_unit_probe_if(
  input logic clk,
  output logic reset_n,
	input logic [31:0] rd_ram_addr,
  output logic [31:0] rd_ram_data);
endinterface


bind top.exec_core exec_unit_probe_if exec_unit_probe_inst(
	.clk(clk),
	.reset_n(reset_n),
	.rd_ram_addr(rd_ram_addr),
	.rd_ram_data(rd_ram_data)
);

module exec_unit_probe_wrapper(
  input logic clk
);
  initial begin
		uvm_config_db #(virtual exec_unit_probe_if)::set(null, "*", "exec_unit_probe_if", top.exec_core.exec_unit_probe_inst);
	end
endmodule

`endif
