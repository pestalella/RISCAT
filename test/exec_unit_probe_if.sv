`ifndef __EXEC_UNIT_PROBE_IF_SV__
`define __EXEC_UNIT_PROBE_IF_SV__

`include "../src/pipeline_stage_registers.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;

interface exec_unit_probe_if(
	input logic clk,
	output logic reset_n,
	input logic [15:0] pc,
	input logic is_jump,
	input logic [20:1] jump_offset,
	input logic [15:0] rd_ram_addr,
	input logic [31:0] rd_ram_data,
	input ID_EX id_ex_r);
endinterface


bind top.exec_core exec_unit_probe_if exec_unit_probe_inst(
	.clk(clk),
	.reset_n(reset_n),
	.pc(id_ex_r.pc),
	.is_jump(id_ex_r.is_jump),
	.jump_offset(id_ex_r.jump_offset),
	.rd_ram_addr(rd_ram_addr),
	.rd_ram_data(rd_ram_data),
	.id_ex_r(id_ex_r)
);

module exec_unit_probe_wrapper(
	input logic clk
);
	initial begin
		uvm_config_db #(virtual exec_unit_probe_if)::set(null, "*", "exec_unit_probe_if", top.exec_core.exec_unit_probe_inst);
	end
endmodule

`endif
