`ifndef __REGISTER32BIT_FILE_SV__
`define __REGISTER32BIT_FILE_SV__

`include "muxers.sv"
`include "register32bit.sv"

module register32bit_file (
	input logic clk,
	input logic reset_n,
	// register reading
	input logic rd0_en,
	input logic [4:0] rd0_addr,
	output logic [31:0] rd0_data,
	// register reading
	input logic rd1_en,
	input logic [4:0] rd1_addr,
	output logic [31:0] rd1_data,
	// register writing
	input logic wr_en,
	input logic [4:0] wr_addr,
	input logic [31:0] wr_data
//		regfile_if reg_if
	);

	wire [31:0][31:0] r_data_out0;
	wire [31:0][31:0] r_data_out1;
	wire [31:0][31:0] r_data_in;
	logic [31:0] rd0_data_r;
	logic [31:0] rd1_data_r;

	assign rd0_data = rd0_en? rd0_data_r : '0;
	assign rd1_data = rd1_en? rd1_data_r : '0;

	mux32to1 rd0_mux(.sel(rd0_addr),
										.in0(0),
										.in1(r_data_out0[1]),
										.in2(r_data_out0[2]),
										.in3(r_data_out0[3]),
										.in4(r_data_out0[4]),
										.in5(r_data_out0[5]),
										.in6(r_data_out0[6]),
										.in7(r_data_out0[7]),
										.in8(r_data_out0[8]),
										.in9(r_data_out0[9]),
										.in10(r_data_out0[10]),
										.in11(r_data_out0[11]),
										.in12(r_data_out0[12]),
										.in13(r_data_out0[13]),
										.in14(r_data_out0[14]),
										.in15(r_data_out0[15]),
										.in16(r_data_out0[16]),
										.in17(r_data_out0[17]),
										.in18(r_data_out0[18]),
										.in19(r_data_out0[19]),
										.in20(r_data_out0[20]),
										.in21(r_data_out0[21]),
										.in22(r_data_out0[22]),
										.in23(r_data_out0[23]),
										.in24(r_data_out0[24]),
										.in25(r_data_out0[25]),
										.in26(r_data_out0[26]),
										.in27(r_data_out0[27]),
										.in28(r_data_out0[28]),
										.in29(r_data_out0[29]),
										.in30(r_data_out0[30]),
										.in31(r_data_out0[31]),
										.out(rd0_data_r));

	mux32to1 rd1_mux(.sel(rd1_addr),
										.in0(0),
										.in1(r_data_out1[1]),
										.in2(r_data_out1[2]),
										.in3(r_data_out1[3]),
										.in4(r_data_out1[4]),
										.in5(r_data_out1[5]),
										.in6(r_data_out1[6]),
										.in7(r_data_out1[7]),
										.in8(r_data_out1[8]),
										.in9(r_data_out1[9]),
										.in10(r_data_out1[10]),
										.in11(r_data_out1[11]),
										.in12(r_data_out1[12]),
										.in13(r_data_out1[13]),
										.in14(r_data_out1[14]),
										.in15(r_data_out1[15]),
										.in16(r_data_out1[16]),
										.in17(r_data_out1[17]),
										.in18(r_data_out1[18]),
										.in19(r_data_out1[19]),
										.in20(r_data_out1[20]),
										.in21(r_data_out1[21]),
										.in22(r_data_out1[22]),
										.in23(r_data_out1[23]),
										.in24(r_data_out1[24]),
										.in25(r_data_out1[25]),
										.in26(r_data_out1[26]),
										.in27(r_data_out1[27]),
										.in28(r_data_out1[28]),
										.in29(r_data_out1[29]),
										.in30(r_data_out1[30]),
										.in31(r_data_out1[31]),
										.out(rd1_data_r));

	demux1to32 wr_demux(.sel(wr_addr),
											.in(wr_data),
											//.out0('Z),  //leave unconnected
											.out1(r_data_in[1]),
											.out2(r_data_in[2]),
											.out3(r_data_in[3]),
											.out4(r_data_in[4]),
											.out5(r_data_in[5]),
											.out6(r_data_in[6]),
											.out7(r_data_in[7]),
											.out8(r_data_in[8]),
											.out9(r_data_in[9]),
											.out10(r_data_in[10]),
											.out11(r_data_in[11]),
											.out12(r_data_in[12]),
											.out13(r_data_in[13]),
											.out14(r_data_in[14]),
											.out15(r_data_in[15]),
											.out16(r_data_in[16]),
											.out17(r_data_in[17]),
											.out18(r_data_in[18]),
											.out19(r_data_in[19]),
											.out20(r_data_in[20]),
											.out21(r_data_in[21]),
											.out22(r_data_in[22]),
											.out23(r_data_in[23]),
											.out24(r_data_in[24]),
											.out25(r_data_in[25]),
											.out26(r_data_in[26]),
											.out27(r_data_in[27]),
											.out28(r_data_in[28]),
											.out29(r_data_in[29]),
											.out30(r_data_in[30]),
											.out31(r_data_in[31])
									);

	genvar i;
	for (i = 1; i < 32; i++) begin : regs   // r0 is just 0
			register32bit r(
					.clk(clk),
					.reset_n(reset_n),
					.data_in(r_data_in[i]),
					.data_out0(r_data_out0[i]),
					.data_out1(r_data_out1[i]),
					.load((wr_addr == i) && wr_en),
					.out0_en((rd0_addr == i) && rd0_en),
					.out1_en((rd1_addr == i) && rd1_en)
					);
	end

endmodule

`endif
