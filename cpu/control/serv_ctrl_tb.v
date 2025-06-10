`timescale 1ns/1ps

module serv_ctrl_tb; 

  parameter RESET_STRATEGY = "MINI";
  parameter RESET_PC = 32'd100;
  parameter WITH_CSR = 1;
  parameter W = 1;
  parameter B = W-1;

  reg clk;
  reg i_rst;
  reg i_pc_en;
  reg i_cnt12to31;
  reg i_cnt0;
  reg i_cnt1;
  reg i_cnt2;
  reg i_jump;
  reg i_jal_or_jalr;
  reg i_utype;
  reg i_pc_rel;
  reg i_trap;
  reg i_iscomp;
  reg [B:0] i_imm;
  reg [B:0] i_buf;
  reg [B:0] i_csr_pc;
  wire [B:0] o_rd;
  wire [B:0] o_bad_pc;
  wire [31:0] o_ibus_adr;

 
  initial clk = 1;
  always #15.625 clk = ~clk;


  serv_ctrl #(
    .RESET_STRATEGY(RESET_STRATEGY),
    .RESET_PC(RESET_PC),
    .WITH_CSR(WITH_CSR),
    .W(W)
  ) dut (
    .clk(clk),
    .i_rst(i_rst),
    .i_pc_en(i_pc_en),
    .i_cnt12to31(i_cnt12to31),
    .i_cnt0(i_cnt0),
    .i_cnt1(i_cnt1),
    .i_cnt2(i_cnt2),
    .i_jump(i_jump),
    .i_jal_or_jalr(i_jal_or_jalr),
    .i_utype(i_utype),
    .i_pc_rel(i_pc_rel),
    .i_trap(i_trap),
    .i_iscomp(i_iscomp),
    .i_imm(i_imm),
    .i_buf(i_buf),
    .i_csr_pc(i_csr_pc),
    .o_rd(o_rd),
    .o_bad_pc(o_bad_pc),
    .o_ibus_adr(o_ibus_adr)
  );

  initial begin
    clk = 0;
    i_rst = 0;
    i_pc_en = 0;
    i_cnt12to31 = 0;
    i_cnt0 = 0;
    i_cnt1 = 0;
    i_cnt2 = 0;
    i_jump = 0;
    i_jal_or_jalr = 0;
    i_utype = 0;
    i_pc_rel = 0;
    i_trap = 0;
    i_iscomp = 0;
    i_imm = 0;
    i_buf = 0;
    i_csr_pc = 0;

    // --------------------------------------
    // TEST CASE 1: Reset Behavior
    // --------------------------------------
    $display("\n--- Test Case 1: Reset ---");
    i_rst = 1;
    i_pc_en = 0;
    i_cnt0 = 0;
    i_cnt1 = 0;
    i_cnt2 = 0;
    i_jump = 0;
    i_jal_or_jalr = 0;
    i_utype = 0;
    i_pc_rel = 0;
    i_trap = 0;
    i_iscomp = 0;
    i_imm = 0;
    i_buf = 0;
    i_csr_pc = 0;

    #(62);
    i_rst = 0;
    #31.25;
    $display("PC after reset: %h", o_ibus_adr);

    // --------------------------------------
    // TEST CASE 2: Normal Increment (pc + 4)
    // --------------------------------------
    $display("\n--- Test Case 2: PC + 4 ---");
    i_rst = 0;
    i_pc_en = 1;
    i_cnt0 = 1;
    i_cnt1 = 0;
    i_cnt2 = 1;
    i_iscomp = 0;
    i_jump = 0;
    i_jal_or_jalr = 0;
    i_utype = 0;
    i_pc_rel = 0;
    i_trap = 0;
    i_imm = 0;
    i_buf = 0;
    i_csr_pc = 0;

    #31.25;
    $display("PC after PC+4: %h", o_ibus_adr);

    // --------------------------------------
    // TEST CASE 3: Compressed Instruction (pc + 2)
    // --------------------------------------
    $display("\n--- Test Case 3: Compressed Instruction ---");
    i_pc_en = 1;
    i_cnt0 = 0;
    i_cnt1 = 1;
    i_cnt2 = 0;
    i_iscomp = 1;
    i_jump = 0;
    i_jal_or_jalr = 0;
    i_utype = 0;
    i_pc_rel = 0;
    i_trap = 0;
    i_imm = 0;
    i_buf = 0;
    i_csr_pc = 0;

    #31.25;
    $display("PC after PC+2: %h", o_ibus_adr);

    // --------------------------------------
    // TEST CASE 4: U-type Jump (new_pc = pc + imm)
    // --------------------------------------
    $display("\n--- Test Case 4: U-type Jump ---");
    i_pc_en = 1;
    i_cnt0 = 1;
    i_cnt1 = 0;
    i_cnt2 = 1;
    i_iscomp = 0;
    i_jump = 1;
    i_jal_or_jalr = 1;
    i_utype = 1;
    i_pc_rel = 1;
    i_trap = 0;
    i_imm = 1;
    i_buf = 0;
    i_csr_pc = 0;
    i_cnt12to31 = 1;

    #31.25;
    $display("PC after U-type Jump: %h", o_ibus_adr);

    // --------------------------------------
    // TEST CASE 5: Trap with CSR PC
    // --------------------------------------
    $display("\n--- Test Case 5: Trap via CSR PC ---");
    i_pc_en = 1;
    i_cnt0 = 0;
    i_cnt1 = 1;
    i_cnt2 = 0;
    i_iscomp = 0;
    i_jump = 0;
    i_jal_or_jalr = 0;
    i_utype = 0;
    i_pc_rel = 0;
    i_trap = 1;
    i_imm = 0;
    i_buf = 0;
    i_csr_pc = 1;
    i_cnt12to31 = 0;

    #31.25;
    $display("PC after Trap: %h", o_ibus_adr);

    $display("\n--- Simulation Complete ---");
    $finish;
  end

endmodule
