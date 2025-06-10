`ifndef __TB_TOP_SV__
`define __TB_TOP_SV__

`timescale 1ns / 1ns

`include "uvm_macros.svh"
`include "exec_core_tests.sv"
`include "register_file_probe_if.sv"
`include "../src/execution_unit.sv"

import uvm_pkg::*;

module top;

	import uvm_pkg::*;
//	import mem_pkg::*;
	//import exec_core_pkg::*;

	logic clk;
	logic reset_n;

	wire [31:0] rd_mem_addr;
	wire [31:0] rd_mem_data;
	wire [31:0] wr_mem_addr;
	wire [31:0] wr_mem_data;
	wire rd_mem_en;
	wire wr_mem_en;

  register_file_probe_wrapper probe_wrapper(.clk(clk));
  exec_unit_probe_wrapper exec_probe_wrapper(.clk(clk));

	// memsys_if memory_interface();

	// memsys #(
	// 	.ADDR_BITS(16)
	// ) memory ( .mem_if(memory_interface) );

	// assign memory_interface.clk = clk;
	// assign memory_interface.rd_en = exec_if.rd_ram_en;
	// assign memory_interface.rd_addr = rd_mem_addr;
	// assign rd_mem_data = memory_interface.rd_data;
	// assign memory_interface.wr_en = wr_mem_en;
	// assign memory_interface.wr_addr = wr_mem_addr;
	// assign memory_interface.wr_data = wr_mem_data;

	exec_unit exec_core(
		.clk(clk),
		.reset_n(reset_n),

		.rd_ram_data(rd_mem_data),
		.wr_ram_en(wr_mem_en),
		.wr_ram_addr(wr_mem_addr),
		.wr_ram_data(wr_mem_data),

		.rd_ram_en(rd_mem_en),
		.rd_ram_addr(rd_mem_addr)
	);

	initial
	begin
		reset_n = 0;
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial
	begin
		$timeformat(-9, 0, " ns", 5); //$timeformat( units_number , precision_number , suffix_string , minimum_field_width )
		//run_test("mem_test");
		//run_test("registerfile_test");
		run_test("exec_core_reset");
	end

endmodule: top

`endif
