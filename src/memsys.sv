`ifndef __MEMSYS_SV__
`define __MEMSYS_SV__

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date: 05/13/2025 08:18:29 PM
// Module Name: memory
//
//////////////////////////////////////////////////////////////////////////////////
`include "uvm_macros.svh"

module read_only_memory#(parameter ADDR_BITS = 16) (
	input  logic clk,
	input  logic rd_en,
	input  logic [15:0] rd_addr,
	output logic [31:0] rd_data
	// input  logic wr_en,
	// input  logic [31:0] wr_addr,
	// output logic [31:0] wr_data
);

	import uvm_pkg::*;

	logic [31:0] data [(1<<ADDR_BITS) - 1:0];
	// assert (rd_addr[31:16] == '0) else
	// 	`uvm_error(get_type_name(), $sformatf("Read address has high bits (>15) set: %h", rd_addr))
	// assert (wr_addr[31:16] == '0) else
	// 	`uvm_error(get_type_name(), $sformatf("Write address has high bits (>15) set: %h", wr_addr))

	assign rd_data = rd_en ? data[rd_addr[ADDR_BITS-1 : 0]] : {32{1'bz}};

	// always_ff @(posedge clk)
	// begin
	// 	if (wr_en)
	// 		data[wr_addr[ADDR_BITS-1 : 0]] <= wr_data;
	// end
endmodule

`endif