`timescale 1ns / 1ns

`include "uvm_macros.svh"

import uvm_pkg::*;

module top;

	import uvm_pkg::*;
	import mem_pkg::*;
	import exec_core_pkg::*;

	logic clk;
	logic reset_n;

	logic [31:0] rd_mem_addr;
	logic [31:0] rd_mem_data;
	logic [31:0] wr_mem_addr;
	logic [31:0] wr_mem_data;
	logic rd_mem_en;
	logic wr_mem_en;

	memsys_if memory_interface();

	memsys #(
		.ADDR_BITS(16)
	) memory ( .mem_if(memory_interface) );

	assign memory_interface.clk = clk;
	assign memory_interface.rd_en = rd_mem_en;
	assign memory_interface.rd_addr = rd_mem_addr;
	assign memory_interface.rd_data = rd_mem_data;
	assign memory_interface.wr_en = wr_mem_en;
	assign memory_interface.wr_addr = wr_mem_addr;
	assign memory_interface.wr_data = wr_mem_data;

	exec_unit_if exec_if(
		.clk(clk),
		.reset_n(reset_n)
	);

	exec_unit exec_core(
		.exec_if(exec_if)
	);

	assign exec_if.rd_ram_en = rd_mem_en;
	assign exec_if.rd_ram_addr = rd_mem_addr;
	assign exec_if.rd_ram_data = rd_mem_data;
	assign exec_if.wr_ram_en = wr_mem_en;
	assign exec_if.wr_ram_addr = wr_mem_addr;
	assign exec_if.wr_ram_data = wr_mem_data;

	initial
	begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial
	begin
		//uvm_config_db #(virtual regfile_if)::set(null, "*", "regfile_if", reg_if);
		//run_test("mem_test");
		//run_test("registerfile_test");
		uvm_config_db #(virtual memsys_if)::set(null, "*", "mem_if", memory_interface);
		uvm_config_db #(virtual exec_unit_if)::set(null, "*", "exec_unit_if", exec_if);
		run_test("exec_core_reset");
	end

endmodule: top
