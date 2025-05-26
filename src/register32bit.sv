`timescale 1ns / 1ns

module register32bit (
    input wire clk,
    input wire reset_n,
    input wire load,
    input wire [31:0] data_in,
    input wire out0_en,
    output wire [31:0] data_out0,
    input wire out1_en,
    output wire [31:0] data_out1
    );

    logic [31:0] bits;
    always @(negedge clk)
        if (!reset_n)
            bits <= 0;
        else if (load) begin
            assert (^data_in !== 1'bX)
                else $display("Assertion fail:  load=1 and data_in=%b", data_in);
            bits <= data_in;
        end

    assign data_out0 = out0_en? bits : {32{1'bz}};
    assign data_out1 = out1_en? bits : {32{1'bz}};
endmodule
