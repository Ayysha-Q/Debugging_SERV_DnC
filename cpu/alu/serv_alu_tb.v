`timescale 1ns/1ps

module serv_alu_tb;


  parameter W = 1;
  parameter B = W - 1;


  reg clk = 0;
  reg i_rst;
  reg i_en;
  reg i_cnt0;
  reg i_sub;
  reg [1:0] i_bool_op;
  reg i_cmp_eq;
  reg i_cmp_sig;
  reg [2:0] i_rd_sel;
  reg [B:0] i_rs1;
  reg [B:0] i_op_b;
  reg [B:0] i_buf;


  wire o_cmp;
  wire [B:0] o_rd;


  serv_alu #(.W(W)) dut (
    .clk(clk),
    .i_rst(i_rst),
    .i_en(i_en),
    .i_cnt0(i_cnt0),
    .o_cmp(o_cmp),
    .i_sub(i_sub),
    .i_bool_op(i_bool_op),
    .i_cmp_eq(i_cmp_eq),
    .i_cmp_sig(i_cmp_sig),
    .i_rd_sel(i_rd_sel),
    .i_rs1(i_rs1),
    .i_op_b(i_op_b),
    .i_buf(i_buf),
    .o_rd(o_rd)
  );


  always #15.625 clk = ~clk;
 

  initial begin
    i_rst = 1;
    i_en = 0;
    i_cnt0 = 0;
    i_sub = 0;
    i_bool_op = 2'b00;
    i_cmp_eq = 0;
    i_cmp_sig = 0;
    i_rd_sel = 3'b001;  // Select ADD result
    i_rs1 = 1'b0;
    i_op_b = 1'b0;
    i_buf = 1'b0;

    $display("Time\tEN\tSUB\tRS1\tOP_B\tRD\tCMP");
    $monitor("%t\t%b\t%b\t%b\t%b\t%b\t%b", $time, i_en, i_sub, i_rs1, i_op_b, o_rd, o_cmp);
    #(62);
    i_rst = 0;

    @(posedge clk);

    // Test ADD: 1 + 0
    i_rs1 = 1'b1;
    i_op_b = 1'b0;
    i_en = 1;
    i_sub = 0;
    i_cnt0 = 1;
    i_rd_sel = 3'b001; // select ADD
    @(posedge clk);

    // Test SUB: 1 - 1
    i_rs1 = 1'b1;
    i_op_b = 1'b1;
    i_sub = 1;
    @(posedge clk);

    // Test Boolean: XOR (1 ^ 0 = 1)
    i_sub = 0;
    i_rd_sel = 3'b100;
    i_bool_op = 2'b00;
    i_rs1 = 1'b1;
    i_op_b = 1'b0;
    i_en = 0;
    @(posedge clk);

    // Test Boolean: AND (1 & 1 = 1)
    i_bool_op = 2'b11;
    i_rs1 = 1'b1;
    i_op_b = 1'b1;
    @(posedge clk);
    


    // Finish
    #50;
    $finish;
  end
endmodule
