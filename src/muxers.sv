
module mux2to1 #(parameter DATA_BITS = 32) (
    input sel,
    input wire [DATA_BITS-1:0] in0,
    input wire [DATA_BITS-1:0] in1,
    output wire [DATA_BITS-1:0] out
    );

    assign out = (sel == 'b0)? in0 : in1;
endmodule

module mux4to1 #(parameter DATA_BITS = 32) (
    input [1:0] sel,
    input wire [DATA_BITS-1:0] in0,
    input wire [DATA_BITS-1:0] in1,
    input wire [DATA_BITS-1:0] in2,
    input wire [DATA_BITS-1:0] in3,
    output wire [DATA_BITS-1:0] out
    );
    assign out = (sel == 'b00)? in0 :
                ((sel == 'b01)? in1 :
                ((sel == 'b10)? in2 :
                                in3));
endmodule

module mux8to1 #(parameter DATA_BITS = 32) (
    input [2:0] sel,
    input wire [DATA_BITS-1:0] in0,
    input wire [DATA_BITS-1:0] in1,
    input wire [DATA_BITS-1:0] in2,
    input wire [DATA_BITS-1:0] in3,
    input wire [DATA_BITS-1:0] in4,
    input wire [DATA_BITS-1:0] in5,
    input wire [DATA_BITS-1:0] in6,
    input wire [DATA_BITS-1:0] in7,
    output wire [DATA_BITS-1:0] out
    );
    logic[DATA_BITS-1:0] low_sel;
    mux4to1 #(.DATA_BITS(DATA_BITS)) low_half(
        .sel(sel[1:0]),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(low_sel)
    );
    logic[DATA_BITS-1:0] high_sel;
    mux4to1 #(.DATA_BITS(DATA_BITS)) high_half(
        .sel(sel[1:0]),
        .in0(in4),
        .in1(in5),
        .in2(in6),
        .in3(in7),
        .out(high_sel)
    );
    mux2to1 #(.DATA_BITS(DATA_BITS)) out_mux(
        .sel(sel[2]),
        .in0(low_sel),
        .in1(high_sel),
        .out(out));
endmodule

module mux16to1 #(parameter DATA_BITS = 32) (
    input [3:0] sel,
    input wire [DATA_BITS-1:0] in0,
    input wire [DATA_BITS-1:0] in1,
    input wire [DATA_BITS-1:0] in2,
    input wire [DATA_BITS-1:0] in3,
    input wire [DATA_BITS-1:0] in4,
    input wire [DATA_BITS-1:0] in5,
    input wire [DATA_BITS-1:0] in6,
    input wire [DATA_BITS-1:0] in7,

    input wire [DATA_BITS-1:0] in8,
    input wire [DATA_BITS-1:0] in9,
    input wire [DATA_BITS-1:0] in10,
    input wire [DATA_BITS-1:0] in11,
    input wire [DATA_BITS-1:0] in12,
    input wire [DATA_BITS-1:0] in13,
    input wire [DATA_BITS-1:0] in14,
    input wire [DATA_BITS-1:0] in15,

    output wire [DATA_BITS-1:0] out
    );
    logic[DATA_BITS-1:0] low_sel;
    mux8to1 #(.DATA_BITS(DATA_BITS)) low_half(
        .sel(sel[2:0]),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .out(low_sel)
    );
    logic[DATA_BITS-1:0] high_sel;
    mux8to1 #(.DATA_BITS(DATA_BITS)) high_half(
        .sel(sel[2:0]),
        .in0(in8),
        .in1(in9),
        .in2(in10),
        .in3(in11),
        .in4(in12),
        .in5(in13),
        .in6(in14),
        .in7(in15),
        .out(high_sel)
    );
    mux2to1 #(.DATA_BITS(DATA_BITS)) out_mux(
        .sel(sel[3]),
        .in0(low_sel),
        .in1(high_sel),
        .out(out));
endmodule

module mux32to1 #(parameter DATA_BITS = 32) (
    input [4:0] sel,
    input wire [DATA_BITS-1:0] in0,
    input wire [DATA_BITS-1:0] in1,
    input wire [DATA_BITS-1:0] in2,
    input wire [DATA_BITS-1:0] in3,
    input wire [DATA_BITS-1:0] in4,
    input wire [DATA_BITS-1:0] in5,
    input wire [DATA_BITS-1:0] in6,
    input wire [DATA_BITS-1:0] in7,
    input wire [DATA_BITS-1:0] in8,
    input wire [DATA_BITS-1:0] in9,
    input wire [DATA_BITS-1:0] in10,
    input wire [DATA_BITS-1:0] in11,
    input wire [DATA_BITS-1:0] in12,
    input wire [DATA_BITS-1:0] in13,
    input wire [DATA_BITS-1:0] in14,
    input wire [DATA_BITS-1:0] in15,

    input wire [DATA_BITS-1:0] in16,
    input wire [DATA_BITS-1:0] in17,
    input wire [DATA_BITS-1:0] in18,
    input wire [DATA_BITS-1:0] in19,
    input wire [DATA_BITS-1:0] in20,
    input wire [DATA_BITS-1:0] in21,
    input wire [DATA_BITS-1:0] in22,
    input wire [DATA_BITS-1:0] in23,
    input wire [DATA_BITS-1:0] in24,
    input wire [DATA_BITS-1:0] in25,
    input wire [DATA_BITS-1:0] in26,
    input wire [DATA_BITS-1:0] in27,
    input wire [DATA_BITS-1:0] in28,
    input wire [DATA_BITS-1:0] in29,
    input wire [DATA_BITS-1:0] in30,
    input wire [DATA_BITS-1:0] in31,

    output wire [DATA_BITS-1:0] out
    );
    logic[DATA_BITS-1:0] low_sel;
    mux16to1 #(.DATA_BITS(DATA_BITS)) low_half(
        .sel(sel[3:0]),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .in8(in8),
        .in9(in9),
        .in10(in10),
        .in11(in11),
        .in12(in12),
        .in13(in13),
        .in14(in14),
        .in15(in15),
        .out(low_sel)
    );
    logic[DATA_BITS-1:0] high_sel;
    mux16to1 #(.DATA_BITS(DATA_BITS)) high_half(
        .sel(sel[3:0]),
		    .in0(in16),
        .in1(in17),
        .in2(in18),
        .in3(in19),
        .in4(in20),
        .in5(in21),
        .in6(in22),
        .in7(in23),
        .in8(in24),
        .in9(in25),
        .in10(in26),
        .in11(in27),
        .in12(in28),
        .in13(in29),
        .in14(in30),
        .in15(in31),
        .out(high_sel)
    );
    mux2to1 #(.DATA_BITS(DATA_BITS)) out_mux(
        .sel(sel[4]),
        .in0(low_sel),
        .in1(high_sel),
        .out(out));
endmodule

module demux1to8 #(parameter DATA_BITS = 32) (
    input logic [2:0] sel,
    input logic [DATA_BITS-1:0] in,
    output logic [DATA_BITS-1:0] out0,
    output logic [DATA_BITS-1:0] out1,
    output logic [DATA_BITS-1:0] out2,
    output logic [DATA_BITS-1:0] out3,
    output logic [DATA_BITS-1:0] out4,
    output logic [DATA_BITS-1:0] out5,
    output logic [DATA_BITS-1:0] out6,
    output logic [DATA_BITS-1:0] out7
    );

    assign out0 = (sel == 'b000) ? in : {DATA_BITS{1'bz}};
    assign out1 = (sel == 'b001) ? in : {DATA_BITS{1'bz}};
    assign out2 = (sel == 'b010) ? in : {DATA_BITS{1'bz}};
    assign out3 = (sel == 'b011) ? in : {DATA_BITS{1'bz}};
    assign out4 = (sel == 'b100) ? in : {DATA_BITS{1'bz}};
    assign out5 = (sel == 'b101) ? in : {DATA_BITS{1'bz}};
    assign out6 = (sel == 'b110) ? in : {DATA_BITS{1'bz}};
    assign out7 = (sel == 'b111) ? in : {DATA_BITS{1'bz}};
endmodule

module demux1to16 #(parameter DATA_BITS = 32) (
    input logic [3:0] sel,
    input logic [DATA_BITS-1:0] in,

    output logic [DATA_BITS-1:0] out0,
    output logic [DATA_BITS-1:0] out1,
    output logic [DATA_BITS-1:0] out2,
    output logic [DATA_BITS-1:0] out3,
    output logic [DATA_BITS-1:0] out4,
    output logic [DATA_BITS-1:0] out5,
    output logic [DATA_BITS-1:0] out6,
    output logic [DATA_BITS-1:0] out7,
    output logic [DATA_BITS-1:0] out8,
    output logic [DATA_BITS-1:0] out9,
    output logic [DATA_BITS-1:0] out10,
    output logic [DATA_BITS-1:0] out11,
    output logic [DATA_BITS-1:0] out12,
    output logic [DATA_BITS-1:0] out13,
    output logic [DATA_BITS-1:0] out14,
    output logic [DATA_BITS-1:0] out15

    );

    assign  out0 = (sel == 'b0000) ? in : {DATA_BITS{1'bz}};
    assign  out1 = (sel == 'b0001) ? in : {DATA_BITS{1'bz}};
    assign  out2 = (sel == 'b0010) ? in : {DATA_BITS{1'bz}};
    assign  out3 = (sel == 'b0011) ? in : {DATA_BITS{1'bz}};
    assign  out4 = (sel == 'b0100) ? in : {DATA_BITS{1'bz}};
    assign  out5 = (sel == 'b0101) ? in : {DATA_BITS{1'bz}};
    assign  out6 = (sel == 'b0110) ? in : {DATA_BITS{1'bz}};
    assign  out7 = (sel == 'b0111) ? in : {DATA_BITS{1'bz}};
    assign  out8 = (sel == 'b1000) ? in : {DATA_BITS{1'bz}};
    assign  out9 = (sel == 'b1001) ? in : {DATA_BITS{1'bz}};
    assign out10 = (sel == 'b1010) ? in : {DATA_BITS{1'bz}};
    assign out11 = (sel == 'b1011) ? in : {DATA_BITS{1'bz}};
    assign out12 = (sel == 'b1100) ? in : {DATA_BITS{1'bz}};
    assign out13 = (sel == 'b1101) ? in : {DATA_BITS{1'bz}};
    assign out14 = (sel == 'b1110) ? in : {DATA_BITS{1'bz}};
    assign out15 = (sel == 'b1111) ? in : {DATA_BITS{1'bz}};
endmodule


module demux1to32 #(parameter DATA_BITS = 32) (
    input logic [4:0] sel,
    input logic [DATA_BITS-1:0] in,
    output logic [DATA_BITS-1:0] out0,
    output logic [DATA_BITS-1:0] out1,
    output logic [DATA_BITS-1:0] out2,
    output logic [DATA_BITS-1:0] out3,
    output logic [DATA_BITS-1:0] out4,
    output logic [DATA_BITS-1:0] out5,
    output logic [DATA_BITS-1:0] out6,
    output logic [DATA_BITS-1:0] out7,
    output logic [DATA_BITS-1:0] out8,
    output logic [DATA_BITS-1:0] out9,
    output logic [DATA_BITS-1:0] out10,
    output logic [DATA_BITS-1:0] out11,
    output logic [DATA_BITS-1:0] out12,
    output logic [DATA_BITS-1:0] out13,
    output logic [DATA_BITS-1:0] out14,
    output logic [DATA_BITS-1:0] out15,

    output logic [DATA_BITS-1:0] out16,
    output logic [DATA_BITS-1:0] out17,
    output logic [DATA_BITS-1:0] out18,
    output logic [DATA_BITS-1:0] out19,
    output logic [DATA_BITS-1:0] out20,
    output logic [DATA_BITS-1:0] out21,
    output logic [DATA_BITS-1:0] out22,
    output logic [DATA_BITS-1:0] out23,
    output logic [DATA_BITS-1:0] out24,
    output logic [DATA_BITS-1:0] out25,
    output logic [DATA_BITS-1:0] out26,
    output logic [DATA_BITS-1:0] out27,
    output logic [DATA_BITS-1:0] out28,
    output logic [DATA_BITS-1:0] out29,
    output logic [DATA_BITS-1:0] out30,
    output logic [DATA_BITS-1:0] out31
    );

    assign  out0  = (sel == 'b00000) ? in : {DATA_BITS{1'bz}};
    assign  out1  = (sel == 'b00001) ? in : {DATA_BITS{1'bz}};
    assign  out2  = (sel == 'b00010) ? in : {DATA_BITS{1'bz}};
    assign  out3  = (sel == 'b00011) ? in : {DATA_BITS{1'bz}};
    assign  out4  = (sel == 'b00100) ? in : {DATA_BITS{1'bz}};
    assign  out5  = (sel == 'b00101) ? in : {DATA_BITS{1'bz}};
    assign  out6  = (sel == 'b00110) ? in : {DATA_BITS{1'bz}};
    assign  out7  = (sel == 'b00111) ? in : {DATA_BITS{1'bz}};
    assign  out8  = (sel == 'b01000) ? in : {DATA_BITS{1'bz}};
    assign  out9  = (sel == 'b01001) ? in : {DATA_BITS{1'bz}};
    assign  out10 = (sel == 'b01010) ? in : {DATA_BITS{1'bz}};
    assign  out11 = (sel == 'b01011) ? in : {DATA_BITS{1'bz}};
    assign  out12 = (sel == 'b01100) ? in : {DATA_BITS{1'bz}};
    assign  out13 = (sel == 'b01101) ? in : {DATA_BITS{1'bz}};
    assign  out14 = (sel == 'b01110) ? in : {DATA_BITS{1'bz}};
    assign  out15 = (sel == 'b01111) ? in : {DATA_BITS{1'bz}};
    assign  out16 = (sel == 'b10000) ? in : {DATA_BITS{1'bz}};
    assign  out17 = (sel == 'b10001) ? in : {DATA_BITS{1'bz}};
    assign  out18 = (sel == 'b10010) ? in : {DATA_BITS{1'bz}};
    assign  out19 = (sel == 'b10011) ? in : {DATA_BITS{1'bz}};
    assign  out20 = (sel == 'b10100) ? in : {DATA_BITS{1'bz}};
    assign  out21 = (sel == 'b10101) ? in : {DATA_BITS{1'bz}};
    assign  out22 = (sel == 'b10110) ? in : {DATA_BITS{1'bz}};
    assign  out23 = (sel == 'b10111) ? in : {DATA_BITS{1'bz}};
    assign  out24 = (sel == 'b11000) ? in : {DATA_BITS{1'bz}};
    assign  out25 = (sel == 'b11001) ? in : {DATA_BITS{1'bz}};
    assign  out26 = (sel == 'b11010) ? in : {DATA_BITS{1'bz}};
    assign  out27 = (sel == 'b11011) ? in : {DATA_BITS{1'bz}};
    assign  out28 = (sel == 'b11100) ? in : {DATA_BITS{1'bz}};
    assign  out29 = (sel == 'b11101) ? in : {DATA_BITS{1'bz}};
    assign  out30 = (sel == 'b11110) ? in : {DATA_BITS{1'bz}};
    assign  out31 = (sel == 'b11111) ? in : {DATA_BITS{1'bz}};
endmodule
