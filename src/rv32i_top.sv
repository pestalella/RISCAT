`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/13/2025 08:18:29 PM
// Design Name:
// Module Name: rv32i_top
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module rv32i_top(
	input wire clk,
	input wire reset_n);

// 	wire [31:0] rd_mem_addr;
// 	wire [31:0] rd_mem_data;
// 	wire [31:0] wr_mem_addr;
// 	wire [31:0] wr_mem_data;
// 	wire exec_unit_rd_mem_en;
// 	wire exec_unit_wr_mem_en;

// //	memsys_if memory_interface();

// 	assign memory_interface.clk = clk;
// 	assign memory_interface.rd_en = rd_mem_en;
// 	assign memory_interface.rd_addr = rd_mem_addr;
// 	assign memory_interface.rd_data = rd_mem_data;
// 	assign memory_interface.wr_en = wr_mem_en;
// 	assign memory_interface.wr_addr = wr_mem_addr;
// 	assign memory_interface.wr_data = wr_mem_data;

// 	memsys#(
// 		.ADDR_BITS(16)
// 	)	ram(
// 		.mem_if(memory_interface)
// 	);

// 	exec_unit exec_core(
// 		.clk(clk),
// 		.reset_n(reset_n),
// 		.rd_ram_en(rd_mem_en),
// 		.rd_ram_addr(rd_mem_addr),
// 		.rd_ram_data(rd_mem_data),
// 		.wr_ram_en(wr_mem_en),
// 		.wr_ram_addr(wr_mem_addr),
// 		.wr_ram_data(wr_mem_data)
// 	);

endmodule
