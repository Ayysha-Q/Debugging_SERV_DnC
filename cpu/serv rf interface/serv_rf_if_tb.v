`timescale 1ns / 1ps
`default_nettype none

module tb_serv_rf_if;

  localparam WITH_CSR = 1;
  localparam W = 1;
  localparam B = W - 1;

  reg clk = 0;
  reg rst = 1;

  always #15.625 clk = ~clk;

  reg i_cnt_en;
  reg i_trap;
  reg i_mret;
  reg [B:0] i_mepc;
  reg i_mtval_pc;
  reg [B:0] i_bufreg_q;
  reg [B:0] i_bad_pc;
  reg i_csr_en;
  reg [1:0] i_csr_addr;
  reg [B:0] i_csr;
  reg i_rd_wen;
  reg [4:0] i_rd_waddr;
  reg [B:0] i_ctrl_rd;
  reg [B:0] i_alu_rd;
  reg i_rd_alu_en;
  reg [B:0] i_csr_rd;
  reg i_rd_csr_en;
  reg [B:0] i_mem_rd;
  reg i_rd_mem_en;
  reg [4:0] i_rs1_raddr;
  reg [4:0] i_rs2_raddr;
  reg [B:0] i_rdata0;
  reg [B:0] i_rdata1;


  wire [4+WITH_CSR:0] o_wreg0;
  wire [4+WITH_CSR:0] o_wreg1;
  wire o_wen0;
  wire o_wen1;
  wire [B:0] o_wdata0;
  wire [B:0] o_wdata1;
  wire [4+WITH_CSR:0] o_rreg0;
  wire [4+WITH_CSR:0] o_rreg1;
  wire [B:0] o_rs1;
  wire [B:0] o_rs2;
  wire [B:0] o_csr;
  wire [B:0] o_csr_pc;


  serv_rf_if #(
    .WITH_CSR(WITH_CSR),
    .W(W),
    .B(B)
  ) dut (
    .i_cnt_en(i_cnt_en),
    .o_wreg0(o_wreg0),
    .o_wreg1(o_wreg1),
    .o_wen0(o_wen0),
    .o_wen1(o_wen1),
    .o_wdata0(o_wdata0),
    .o_wdata1(o_wdata1),
    .o_rreg0(o_rreg0),
    .o_rreg1(o_rreg1),
    .i_rdata0(i_rdata0),
    .i_rdata1(i_rdata1),
    .i_trap(i_trap),
    .i_mret(i_mret),
    .i_mepc(i_mepc),
    .i_mtval_pc(i_mtval_pc),
    .i_bufreg_q(i_bufreg_q),
    .i_bad_pc(i_bad_pc),
    .o_csr_pc(o_csr_pc),
    .i_csr_en(i_csr_en),
    .i_csr_addr(i_csr_addr),
    .i_csr(i_csr),
    .o_csr(o_csr),
    .i_rd_wen(i_rd_wen),
    .i_rd_waddr(i_rd_waddr),
    .i_ctrl_rd(i_ctrl_rd),
    .i_alu_rd(i_alu_rd),
    .i_rd_alu_en(i_rd_alu_en),
    .i_csr_rd(i_csr_rd),
    .i_rd_csr_en(i_rd_csr_en),
    .i_mem_rd(i_mem_rd),
    .i_rd_mem_en(i_rd_mem_en),
    .i_rs1_raddr(i_rs1_raddr),
    .o_rs1(o_rs1),
    .i_rs2_raddr(i_rs2_raddr),
    .o_rs2(o_rs2)
  );

  initial begin
    i_cnt_en = 0;
    i_trap = 0;
    i_mret = 0;
    i_mepc = 0;
    i_mtval_pc = 0;
    i_bufreg_q = 0;
    i_bad_pc = 0;
    i_csr_en = 0;
    i_csr_addr = 0;
    i_csr = 0;
    i_rd_wen = 0;
    i_rd_waddr = 0;
    i_ctrl_rd = 0;
    i_alu_rd = 0;
    i_rd_alu_en = 0;
    i_csr_rd = 0;
    i_rd_csr_en = 0;
    i_mem_rd = 0;
    i_rd_mem_en = 0;
    i_rs1_raddr = 0;
    i_rs2_raddr = 0;
    i_rdata0 = 0;
    i_rdata1 = 0;

  
    #62 rst = 0;

    i_cnt_en = 1;

    // Example 1: Write from ALU
    i_rd_wen = 1;
    i_rd_waddr = 5'd3;
    i_alu_rd = 1'b1;
    i_rd_alu_en = 1;
    i_ctrl_rd = 0;
    #31.25;

    // Example 2: Trap active
    i_trap = 1;
    i_bufreg_q = 1'b1;
    i_bad_pc = 0;
    i_mtval_pc = 0;
    i_mepc = 1'b0;
    #31.25;

    // Example 3: CSR Access
    i_trap = 0;
    i_rd_wen = 0;
    i_csr_en = 1;
    i_csr_addr = 2'b01;
    i_csr = 1'b1;
    #31.25;

    // Example 4: Read RS1/RS2
    i_rs1_raddr = 5'd1;
    i_rs2_raddr = 5'd2;
    i_rdata0 = 1'b1;
    i_rdata1 = 1'b0;
    #31.25;

    // Done
    $finish;
  end

endmodule
