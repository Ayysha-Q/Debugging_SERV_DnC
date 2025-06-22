`timescale 1ns/1ps

module servile_arbiter_tb;

  // Clock generation (32 MHz)
  reg clk = 0;
  always #15.625 clk = ~clk;

  // Inputs
  reg [31:0] i_wb_cpu_dbus_adr;
  reg [31:0] i_wb_cpu_dbus_dat;
  reg [3:0]  i_wb_cpu_dbus_sel;
  reg        i_wb_cpu_dbus_we;
  reg        i_wb_cpu_dbus_stb;

  reg [31:0] i_wb_cpu_ibus_adr;
  reg        i_wb_cpu_ibus_stb;

  reg [31:0] i_wb_mem_rdt;
  reg        i_wb_mem_ack;

  // Outputs
  wire [31:0] o_wb_cpu_dbus_rdt;
  wire        o_wb_cpu_dbus_ack;
  wire [31:0] o_wb_cpu_ibus_rdt;
  wire        o_wb_cpu_ibus_ack;

  wire [31:0] o_wb_mem_adr;
  wire [31:0] o_wb_mem_dat;
  wire [3:0]  o_wb_mem_sel;
  wire        o_wb_mem_we;
  wire        o_wb_mem_stb;

  // Instantiate DUT
  servile_arbiter dut (
    .i_wb_cpu_dbus_adr(i_wb_cpu_dbus_adr),
    .i_wb_cpu_dbus_dat(i_wb_cpu_dbus_dat),
    .i_wb_cpu_dbus_sel(i_wb_cpu_dbus_sel),
    .i_wb_cpu_dbus_we(i_wb_cpu_dbus_we),
    .i_wb_cpu_dbus_stb(i_wb_cpu_dbus_stb),
    .o_wb_cpu_dbus_rdt(o_wb_cpu_dbus_rdt),
    .o_wb_cpu_dbus_ack(o_wb_cpu_dbus_ack),
    .i_wb_cpu_ibus_adr(i_wb_cpu_ibus_adr),
    .i_wb_cpu_ibus_stb(i_wb_cpu_ibus_stb),
    .o_wb_cpu_ibus_rdt(o_wb_cpu_ibus_rdt),
    .o_wb_cpu_ibus_ack(o_wb_cpu_ibus_ack),
    .o_wb_mem_adr(o_wb_mem_adr),
    .o_wb_mem_dat(o_wb_mem_dat),
    .o_wb_mem_sel(o_wb_mem_sel),
    .o_wb_mem_we(o_wb_mem_we),
    .o_wb_mem_stb(o_wb_mem_stb),
    .i_wb_mem_rdt(i_wb_mem_rdt),
    .i_wb_mem_ack(i_wb_mem_ack)
  );

  initial begin
    // Initial state
    i_wb_cpu_dbus_adr = 0;
    i_wb_cpu_dbus_dat = 0;
    i_wb_cpu_dbus_sel = 4'b1111;
    i_wb_cpu_dbus_we = 0;
    i_wb_cpu_dbus_stb = 0;

    i_wb_cpu_ibus_adr = 0;
    i_wb_cpu_ibus_stb = 0;

    i_wb_mem_rdt = 32'hAABBCCDD;
    i_wb_mem_ack = 0;

    // Reset duration (simulate 62 ns)
    #62;

    // Instruction fetch
    @(negedge clk);
    i_wb_cpu_ibus_adr = 32'h0000_1000;
    i_wb_cpu_ibus_stb = 1;
    @(negedge clk);
    i_wb_mem_ack = 1;
    @(negedge clk);
    i_wb_mem_ack = 0;
    i_wb_cpu_ibus_stb = 0;

    // Data write (no ibus active)
    @(negedge clk);
    i_wb_cpu_dbus_adr = 32'h0000_2000;
    i_wb_cpu_dbus_dat = 32'h11223344;
    i_wb_cpu_dbus_we  = 1;
    i_wb_cpu_dbus_stb = 1;
    @(negedge clk);
    i_wb_mem_ack = 1;
    @(negedge clk);
    i_wb_mem_ack = 0;
    i_wb_cpu_dbus_stb = 0;

    // Both active: ibus takes priority
    @(negedge clk);
    i_wb_cpu_dbus_adr = 32'h0000_3000;
    i_wb_cpu_dbus_dat = 32'h55667788;
    i_wb_cpu_dbus_we  = 1;
    i_wb_cpu_dbus_stb = 1;
    i_wb_cpu_ibus_adr = 32'h0000_4000;
    i_wb_cpu_ibus_stb = 1;
    @(negedge clk);
    i_wb_mem_ack = 1;
    @(negedge clk);
    i_wb_mem_ack = 0;
    i_wb_cpu_dbus_stb = 0;
    i_wb_cpu_ibus_stb = 0;

    #100;
    $finish;
  end

endmodule
