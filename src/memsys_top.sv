`timescale 1ns / 1ps

module memsys_top(
	logic clk
	);

	memsys_if#(.ADDR_BITS(16), .DATA_BITS(32)) mem_if();
	assign mem_if.clk = clk;
	memsys#(.ADDR_BITS(16), .DATA_BITS(32)) memory(.mem_if(mem_if));

endmodule
