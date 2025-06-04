`timescale 1ns/1ps

module tb_serv_rf_ram_if;

  // Parameters (based on default values)
  localparam WIDTH = 8;
  localparam W = 1;
  localparam CSR_REGS = 4;
  localparam RAW = $clog2(32 + CSR_REGS);
  localparam B = W - 1;
  localparam CMSB = 4-$clog2(W);
  localparam L2W = $clog2(WIDTH);
  localparam AW = 5 + RAW - L2W;

  // Clock and reset
  reg clk = 1;
  reg rst = 1;

  // SERV interface
  reg i_wreq = 0;
  reg i_rreq = 0;
  wire o_ready;

  reg [RAW-1:0] i_wreg0 = 0;
  reg [RAW-1:0] i_wreg1 = 0;
  reg          i_wen0 = 0;
  reg          i_wen1 = 0;
  reg [B:0]    i_wdata0 = 0;
  reg [B:0]    i_wdata1 = 0;

  reg [RAW-1:0] i_rreg0 = 0;
  reg [RAW-1:0] i_rreg1 = 0;
  wire [B:0]    o_rdata0;
  wire [B:0]    o_rdata1;

  // RAM interface
  wire [AW-1:0] o_waddr;
  wire [WIDTH-1:0] o_wdata;
  wire o_wen;
  wire [AW-1:0] o_raddr;
  wire o_ren;
  wire [CMSB:0] o_rcnt;
  wire [CMSB:0] o_wcnt;
  wire [WIDTH-1:0] o_wdata0_r;
  wire [WIDTH-1:0] o_wdata1_r;
  reg i_rdata = 0;

  // Clock generator: 32MHz -> 31.25ns period
  always #15.625 clk = ~clk;

  // DUT instantiation
  serv_rf_ram_if #(
    .width(WIDTH),
    .W(W),
    .reset_strategy("MINI"),
    .csr_regs(CSR_REGS)
  ) dut (
    .i_clk(clk),
    .i_rst(rst),
    .i_wreq(i_wreq),
    .i_rreq(i_rreq),
    .o_ready(o_ready),
    .i_wreg0(i_wreg0),
    .i_wreg1(i_wreg1),
    .i_wen0(i_wen0),
    .i_wen1(i_wen1),
    .i_wdata0(i_wdata0),
    .i_wdata1(i_wdata1),
    .i_rreg0(i_rreg0),
    .i_rreg1(i_rreg1),
    .o_rdata0(o_rdata0),
    .o_rdata1(o_rdata1),
    .o_waddr(o_waddr),
    .o_wdata(o_wdata),
    .o_wen(o_wen),
    .o_raddr(o_raddr),
    .o_ren(o_ren),
    .o_wcnt(o_wcnt),
    .o_rcnt(o_rcnt),
    .o_wdata0_r(o_wdata0_r),
    .o_wdata1_r(o_wdata1_r),
    .i_rdata(i_rdata)
  );

  initial begin
    $dumpfile("tb_serv_rf_ram_if.vcd");
    $dumpvars(0, tb_serv_rf_ram_if);

    // Initial reset (for 62 ns)
    #62;
    rst = 0;

    // Wait for a few clock cycles
    #50;

    // Perform a write request
    i_wreq = 1;
    i_wreg0 = 3;
    i_wreg1 = 4;
    i_wen0 = 1;
    i_wen1 = 1;
    i_wdata0 = 1'b1;
    i_wdata1 = 1'b0;
    #31.25;  // 1 cycle

    i_wreq = 0;
    i_wen0 = 0;
    i_wen1 = 0;

    #100;

    // Perform a read request
    i_rreq = 1;
    i_rreg0 = 3;
    i_rreg1 = 4;
    i_rdata = 1'b1;  // simulate RAM returning 1
    i_wen0 = 1'b1;
    i_wen1 = 1'b1;
    #31.25;

    i_rreq = 0;

    // Let simulation run
    #200;

    $display("Testbench finished.");
    $finish;
  end

endmodule
