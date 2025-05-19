`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer:
//
// Create Date: 05/13/2025 08:18:29 PM
// Module Name: rv32i_top
// Project Name:
// Description:
//
//////////////////////////////////////////////////////////////////////////////////
`include "uvm_macros.svh"

`timescale 1ns / 1ps

interface memsys_if#(
		parameter ADDR_BITS = 16,
			      DATA_BITS = 32
	);

	logic clk;
	logic rd_en;
	logic [ADDR_BITS-1:0] rd_addr;
	logic [DATA_BITS-1:0] rd_data;
	logic wr_en;
	logic [ADDR_BITS-1:0] wr_addr;
	logic [DATA_BITS-1:0] wr_data;

endinterface

module memsys#(
    parameter ADDR_BITS = 16,
              DATA_BITS = 32
	)	(	memsys_if mem_if );

	import uvm_pkg::*;

	logic [DATA_BITS-1:0] memory [(1<<ADDR_BITS) - 1:0];

	assign mem_if.rd_data = mem_if.rd_en ? memory[mem_if.rd_addr] : {DATA_BITS{1'bz}};

	always @(posedge mem_if.clk)
	begin
		if (mem_if.wr_en)
			memory[mem_if.wr_addr] <= mem_if.wr_data;
	end
endmodule
