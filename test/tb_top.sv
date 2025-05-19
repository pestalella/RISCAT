`include "uvm_macros.svh"

import uvm_pkg::*;

module top;

	import uvm_pkg::*;
	import mem_pkg::*;
	import register_pkg::*;

	memsys_if #(
		.ADDR_BITS(4),
		.DATA_BITS(8)
	) mem_if();

	memsys #(
		.ADDR_BITS(4),
		.DATA_BITS(8)
	) mem_dut ( .mem_if(mem_if) );

	regfile_if reg_if();
	register32bit_file dut(reg_if);

	initial
	begin
		mem_if.clk = 0;
		forever #5 mem_if.clk = ~mem_if.clk;
	end

	initial
	begin
		reg_if.clk = 0;
		forever #5 reg_if.clk = ~reg_if.clk;
	end

	initial
	begin
		uvm_config_db #(virtual memsys_if#(.ADDR_BITS(4),.DATA_BITS(8)))::set(null, "*", "memsys_if", mem_if);
		uvm_config_db #(virtual regfile_if)::set(null, "*", "regfile_if", reg_if);
		//run_test("mem_test");
		run_test("registerfile_test");
	end

endmodule: top
