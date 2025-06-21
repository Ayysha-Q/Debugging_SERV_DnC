`timescale 1ns/1ps

module tb_servile_mux;

  reg i_clk = 0;
  always #15.625 i_clk = ~i_clk;  // 32 MHz => 1/32e6 = 31.25 ns period

  reg i_rst;
  reg [31:0] i_wb_cpu_adr;
  reg [31:0] i_wb_cpu_dat;
  reg [3:0]  i_wb_cpu_sel;
  reg        i_wb_cpu_we;
  reg        i_wb_cpu_stb;
  wire [31:0] o_wb_cpu_rdt;
  wire        o_wb_cpu_ack;

  wire [31:0] o_wb_mem_adr;
  wire [31:0] o_wb_mem_dat;
  wire [3:0]  o_wb_mem_sel;
  wire        o_wb_mem_we;
  wire        o_wb_mem_stb;
  reg [31:0]  i_wb_mem_rdt;
  reg         i_wb_mem_ack;

  wire [31:0] o_wb_ext_adr;
  wire [31:0] o_wb_ext_dat;
  wire [3:0]  o_wb_ext_sel;
  wire        o_wb_ext_we;
  wire        o_wb_ext_stb;
  reg [31:0]  i_wb_ext_rdt;
  reg         i_wb_ext_ack;

  // Instantiate DUT
  servile_mux dut (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_wb_cpu_adr(i_wb_cpu_adr),
    .i_wb_cpu_dat(i_wb_cpu_dat),
    .i_wb_cpu_sel(i_wb_cpu_sel),
    .i_wb_cpu_we(i_wb_cpu_we),
    .i_wb_cpu_stb(i_wb_cpu_stb),
    .o_wb_cpu_rdt(o_wb_cpu_rdt),
    .o_wb_cpu_ack(o_wb_cpu_ack),
    .o_wb_mem_adr(o_wb_mem_adr),
    .o_wb_mem_dat(o_wb_mem_dat),
    .o_wb_mem_sel(o_wb_mem_sel),
    .o_wb_mem_we(o_wb_mem_we),
    .o_wb_mem_stb(o_wb_mem_stb),
    .i_wb_mem_rdt(i_wb_mem_rdt),
    .i_wb_mem_ack(i_wb_mem_ack),
    .o_wb_ext_adr(o_wb_ext_adr),
    .o_wb_ext_dat(o_wb_ext_dat),
    .o_wb_ext_sel(o_wb_ext_sel),
    .o_wb_ext_we(o_wb_ext_we),
    .o_wb_ext_stb(o_wb_ext_stb),
    .i_wb_ext_rdt(i_wb_ext_rdt),
    .i_wb_ext_ack(i_wb_ext_ack)
  );

  initial begin
    // Initialize
    i_rst = 1;
    i_wb_cpu_adr = 0;
    i_wb_cpu_dat = 0;
    i_wb_cpu_sel = 4'b1111;
    i_wb_cpu_we = 0;
    i_wb_cpu_stb = 0;
    i_wb_mem_rdt = 32'hFFEEDDCC;
    i_wb_mem_ack = 0;
    i_wb_ext_rdt = 32'hAABBCCDD;
    i_wb_ext_ack = 0;

    // Hold reset for 62 ns
    #62;
    i_rst = 0;

    // Memory access (addr[31:30] = 2'b00)
    @(negedge i_clk);
    i_wb_cpu_adr = 32'h0000_1000;
    i_wb_cpu_dat = 32'h12345678;
    i_wb_cpu_we  = 1;
    i_wb_cpu_stb = 1;
    @(negedge i_clk);
    i_wb_mem_ack = 1;
    @(negedge i_clk);
    i_wb_mem_ack = 0;
    i_wb_cpu_stb = 0;

    // External access (addr[31:30] != 2'b00)
    @(negedge i_clk);
    i_wb_cpu_adr = 32'hC000_0000;  // MSBs = 2'b11
    i_wb_cpu_dat = 32'hA5A5A5A5;
    i_wb_cpu_we  = 1;
    i_wb_cpu_stb = 1;
    @(negedge i_clk);
    i_wb_ext_ack = 1;
    @(negedge i_clk);
    i_wb_ext_ack = 0;
    i_wb_cpu_stb = 0;

    // Finish
    #100;
    $finish;
  end

endmodule
