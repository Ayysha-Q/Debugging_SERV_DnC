`timescale 1ns / 1ps

module serv_state_tb;

  localparam RESET_STRATEGY = "MINI";
  localparam WITH_CSR = 1;
  localparam [0:0] ALIGN =0;
  localparam [0:0] MDU = 0;
  localparam W = 1;
  
  reg i_clk;
  reg i_rst;


  reg i_new_irq;
  reg i_alu_cmp;
  reg i_ctrl_misalign;
  reg i_sh_done;
  reg i_sh_done_r;
  reg i_mem_misalign;
  reg i_bne_or_bge;
  reg i_cond_branch;
  reg i_dbus_en;
  reg i_two_stage_op;
  reg i_branch_op;
  reg i_shift_op;
  reg i_sh_right;
  reg i_slt_or_branch;
  reg i_e_op;
  reg i_rd_op;
  reg i_dbus_ack;
  reg i_ibus_ack;
  reg i_rf_ready;


  wire o_init;
  wire o_cnt_en;
  wire o_cnt0to3;
  wire o_cnt12to31;
  wire o_cnt0;
  wire o_cnt1;
  wire o_cnt2;
  wire o_cnt3;
  wire o_cnt7;
  wire o_cnt11;
  wire o_cnt12;
  wire o_cnt_done;
  wire o_bufreg_en;
  wire o_ctrl_pc_en;
  wire o_ctrl_trap;
  wire o_mdu_valid;
  wire o_dbus_cyc;
  wire o_ibus_cyc;
  wire o_rf_rreq;
  wire o_rf_wreq;
  wire o_rf_rd_en;
  wire [1:0] o_mem_bytecnt;
  wire o_ctrl_jump;
  wire init_done_out;
  wire stage_two_req_out;
  wire [4:2] o_cnt_out;
  wire [3:0] cnt_r_out;
  wire misalign_trap_sync_out;
  wire ibus_cyc_out;

 
  initial i_clk = 1;
  always #15.625 i_clk = ~i_clk;


  serv_state #(
    .RESET_STRATEGY("MINI"),
    .WITH_CSR(1),
    .ALIGN(0),
    .MDU(0),
    .W(1)
  ) dut (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_new_irq(i_new_irq),
    .i_alu_cmp(i_alu_cmp),
    .o_init(o_init),
    .o_cnt_en(o_cnt_en),
    .o_cnt0to3(o_cnt0to3),
    .o_cnt12to31(o_cnt12to31),
    .o_cnt0(o_cnt0),
    .o_cnt1(o_cnt1),
    .o_cnt2(o_cnt2),
    .o_cnt3(o_cnt3),
    .o_cnt7(o_cnt7),
    .o_cnt11(o_cnt11),
    .o_cnt12(o_cnt12),
    .o_cnt_done(o_cnt_done),
    .o_bufreg_en(o_bufreg_en),
    .o_ctrl_pc_en(o_ctrl_pc_en),
    .o_ctrl_jump(o_ctrl_jump),
    .o_ctrl_trap(o_ctrl_trap),
    .i_ctrl_misalign(i_ctrl_misalign),
    .i_sh_done(i_sh_done),
    .i_sh_done_r(i_sh_done_r),
    .o_mem_bytecnt(o_mem_bytecnt),
    .i_mem_misalign(i_mem_misalign),
    .i_bne_or_bge(i_bne_or_bge),
    .i_cond_branch(i_cond_branch),
    .i_dbus_en(i_dbus_en),
    .i_two_stage_op(i_two_stage_op),
    .i_branch_op(i_branch_op),
    .i_shift_op(i_shift_op),
    .i_sh_right(i_sh_right),
    .i_slt_or_branch(i_slt_or_branch),
    .i_e_op(i_e_op),
    .i_rd_op(i_rd_op),
    .o_mdu_valid(o_mdu_valid),
    .o_dbus_cyc(o_dbus_cyc),
    .i_dbus_ack(i_dbus_ack),
    .o_ibus_cyc(o_ibus_cyc),
    .i_ibus_ack(i_ibus_ack),
    .o_rf_rreq(o_rf_rreq),
    .o_rf_wreq(o_rf_wreq),
    .i_rf_ready(i_rf_ready),
    .o_rf_rd_en(o_rf_rd_en),
    .init_done_out(init_done_out),
    .stage_two_req_out(stage_two_req_out),
    .cnt_r_out(cnt_r_out),
    .o_cnt_out(o_cnt_out),
    .ibus_cyc_out(ibus_cyc_out),
    .misalign_trap_sync_out(misalign_trap_sync_out)
  );


  initial begin
    i_rst = 1;
    i_new_irq = 0;
    i_alu_cmp = 0;
    i_ctrl_misalign = 0;
    i_sh_done = 0;
    i_sh_done_r = 0;
    i_mem_misalign = 0;
    i_bne_or_bge = 0;
    i_cond_branch = 0;
    i_dbus_en = 0;
    i_two_stage_op = 0;
    i_branch_op = 0;
    i_shift_op = 0;
    i_sh_right = 0;
    i_slt_or_branch = 0;
    i_e_op = 0;
    i_rd_op = 0;
    i_dbus_ack = 0;
    i_ibus_ack = 0;
    i_rf_ready = 0;


    #62 i_rst = 0;
    #30 i_new_irq = 1;
    #40 i_new_irq = 0;


    #10;
    i_two_stage_op = 1;
    i_rf_ready = 1;

    #50;
    i_ibus_ack = 1;
    #10 i_ibus_ack = 0;

    #100;
    i_rf_ready = 0;
    
    i_new_irq = 1;
    i_alu_cmp = 1;
    i_ctrl_misalign = 1;
    i_sh_done = 0;
    i_sh_done_r = 1;
    i_mem_misalign = 1;
    i_bne_or_bge = 0;
    i_cond_branch = 1;
    i_dbus_en = 1;
    i_two_stage_op = 1;
    i_branch_op = 0;
    i_shift_op = 1;
    i_sh_right = 1;
    i_slt_or_branch = 1;
    i_e_op = 0;
    i_rd_op = 0;
    i_dbus_ack = 1;
    i_ibus_ack = 1;
    i_rf_ready = 0;

#100;
    i_new_irq = 0;
    i_alu_cmp = 0;
    i_ctrl_misalign = 0;
    i_sh_done = 1;
    #20;
    i_sh_done_r = 0;
    i_mem_misalign = 0;
    i_bne_or_bge = 1;
    i_cond_branch = 0;
    i_dbus_en = 0;
    i_two_stage_op = 0;
    i_branch_op = 1;
    #20;
    i_shift_op = 0;
    i_sh_right = 0;
    i_slt_or_branch = 0;
    i_e_op = 1;
    #20;
    i_rd_op = 1;
    i_dbus_ack = 0;
    i_ibus_ack = 0;
    i_rf_ready = 1;

    #1000  i_two_stage_op = 1;
    #500 $finish;
  end

endmodule

