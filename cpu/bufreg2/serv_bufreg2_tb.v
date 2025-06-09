`timescale 1ns / 1ps

module serv_bufreg2_tb;

  reg         i_clk;
  reg         i_en;
  reg         i_init;
  reg         i_cnt_done;
  reg  [1:0]  i_lsb;
  reg         i_byte_valid;
  wire        o_sh_done;
  wire        o_sh_done_r;
  reg         i_op_b_sel;
  reg         i_shift_op;
  reg         i_rs2;
  reg         i_imm;
  wire        o_op_b;
  wire        o_q;
  wire [31:0] o_dat;
  reg         i_load;
  reg  [31:0] i_dat;


  serv_bufreg2 uut (
    .i_clk(i_clk),
    .i_en(i_en),
    .i_init(i_init),
    .i_cnt_done(i_cnt_done),
    .i_lsb(i_lsb),
    .i_byte_valid(i_byte_valid),
    .o_sh_done(o_sh_done),
    .o_sh_done_r(o_sh_done_r),
    .i_op_b_sel(i_op_b_sel),
    .i_shift_op(i_shift_op),
    .i_rs2(i_rs2),
    .i_imm(i_imm),
    .o_op_b(o_op_b),
    .o_q(o_q),
    .o_dat(o_dat),
    .i_load(i_load),
    .i_dat(i_dat)
  );


  always begin
    #15.625 i_clk = ~i_clk;  
  end

  initial begin
    i_clk = 1;
    i_en = 0;
    i_init = 0;
    i_cnt_done = 0;
    i_lsb = 2'b00;
    i_byte_valid = 0;
    i_op_b_sel = 0;
    i_shift_op = 0;
    i_rs2 = 0;
    i_imm = 1;
    i_load = 0;
    i_dat = 32'hAABBCCDD;

    #50;

    // Test: Load data into dat register
    i_load = 1;
    #31.25;
    i_load = 0;

    // Test: Shift with imm
    i_op_b_sel = 0;     
    i_shift_op = 1;
    i_init = 1;
    i_en = 1;
    i_byte_valid = 1;
    i_cnt_done = 0;

    #31.25;
    i_init = 0;

    repeat (5) begin
      #31.25;
    end

    // Test: Change to rs2 input
    i_op_b_sel = 1;
    i_rs2 = 1;

    #62.5;

    // Test: Check o_q based on lsb
    i_lsb = 2'b00; #31.25;
    i_lsb = 2'b01; #31.25;
    i_lsb = 2'b10; #31.25;
    i_lsb = 2'b11; #31.25;

    #100;
    $finish;
  end

endmodule
