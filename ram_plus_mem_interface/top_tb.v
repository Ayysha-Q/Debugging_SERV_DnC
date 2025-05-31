`timescale 1ns / 1ps

module top_tb;

  // Parameters
  parameter MEMSIZE = 1024;

  // Clock and reset
  reg clk = 1;
  reg rst = 1;

  // Clock generation for 32 MHz
  always #15.625 clk = ~clk;

  // DUT I/O signals
  reg [7:0]  i_raddr_top;
  reg        i_ren_top;
  reg [7:0]  i_waddr_top;
  reg [9:2]  i_wb_adr_top;
  reg [31:0] i_wb_dat_top;
  reg [3:0]  i_wb_sel_top;
  reg        i_wb_stb_top;
  reg        i_wb_we_top;
  reg [7:0]  i_wdata_top;
  //reg        sel_wen_top;
  reg        i_wen_top;

  wire [7:0]  o_rdata_top;
  wire        o_wb_ack_top;
  wire [31:0] o_wb_rdt_top;

  // Instantiate DUT without using any memfile
  top_ram_memif #(
    .memfile(""),  // <-- Empty file disables $readmemh
    .memsize(MEMSIZE)
  ) dut (
    .clk_top(clk),
    .rst_top(rst),
    .i_raddr_top(i_raddr_top),
    .i_ren_top(i_ren_top),
    .i_waddr_top(i_waddr_top),
    .i_wb_adr_top(i_wb_adr_top),
    .i_wb_dat_top(i_wb_dat_top),
    .i_wb_sel_top(i_wb_sel_top),
    .i_wb_stb_top(i_wb_stb_top),
    .i_wb_we_top(i_wb_we_top),
    .i_wdata_top(i_wdata_top),
    //.sel_wen_top(sel_wen_top),
    .i_wen_top(i_wen_top),
    .o_rdata_top(o_rdata_top),
    .o_wb_ack_top(o_wb_ack_top),
    .o_wb_rdt_top(o_wb_rdt_top)
  );

  // Stimulus
  initial begin
    $display("Running RAM translation/access test...");

    $dumpfile("tb_top_ram_memif.vcd");
    $dumpvars(0, top_tb);

    // Initialize inputs
    {i_raddr_top, i_ren_top, i_waddr_top, i_wb_adr_top, i_wb_dat_top,
     i_wb_sel_top, i_wb_stb_top, i_wb_we_top, i_wdata_top, i_wen_top} = 0;

     
    // Reset
    #62 rst = 0;

    // Write to RAM through interface
    @(posedge clk);
    i_waddr_top  = 8'h0A;
    i_wdata_top  = 8'h5A;
    //sel_wen_top  = 1;
    i_wen_top    = 1;

    @(posedge clk);
    i_wen_top = 0;
    i_ren_top = 1;
    i_raddr_top = 8'h0A;

    // Read from same address
    @(posedge clk);
    i_raddr_top = 8'h0A;
    i_ren_top   = 0;

    @(posedge clk);
    i_ren_top = 1;

    // Wait and check output
    repeat (5) @(posedge clk);
    $display("[READ TEST] Addr: 0x%02X, Expected: 0x5A, Got: 0x%02X", i_raddr_top, o_rdata_top);

    $finish;
  end

endmodule
