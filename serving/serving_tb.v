`timescale 1ns/1ps

module serving_tb;

  // Clock frequency = 32 MHz ? T = 31.25 ns
  reg i_clk = 1;
  always #15.625 i_clk = ~i_clk;

  reg i_rst;
  reg i_timer_irq;

  // Bridge I/O
  wire [11:2] o_wb_addr;
  wire [31:0] o_wb_dat;
  wire [3:0] o_wb_sel;
  wire o_wb_we, o_wb_stb;
  reg  [31:0] i_wb_rdt;
  reg  i_wb_ack;

  reg [11:2] adr_brg;
  reg [31:0] data_brg;
  reg        stb_brg;
  reg        wen_brg;
  reg [3:0]  sel_brg;
  wire [31:0] rdt_brg;
  wire ack_brg;

  reg sel_wadr, sel_wdata, sel_radr, sel_rdata, sel_wen;

  // Instantiate the DUT
  serving dut (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_timer_irq(i_timer_irq),
    .o_wb_addr(o_wb_addr),
    .o_wb_dat(o_wb_dat),
    .o_wb_sel(o_wb_sel),
    .o_wb_we(o_wb_we),
    .o_wb_stb(o_wb_stb),
    .i_wb_rdt(i_wb_rdt),
    .i_wb_ack(i_wb_ack),
    .adr_brg(adr_brg),
    .data_brg(data_brg),
    .stb_brg(stb_brg),
    .wen_brg(wen_brg),
    .sel_brg(sel_brg),
    .rdt_brg(rdt_brg),
    .ack_brg(ack_brg),
    .sel_wadr(sel_wadr),
    .sel_wdata(sel_wdata),
    .sel_radr(sel_radr),
    .sel_rdata(sel_rdata),
    .sel_wen(sel_wen)
  );

  initial begin
    $display("Starting serving_tb...");
    // Default signals
    i_timer_irq = 0;
    adr_brg     = 10'h000;
    data_brg    = 32'h0;
    stb_brg     = 0;
    wen_brg     = 0;
    sel_brg     = 4'b0000;
    i_wb_rdt    = 32'hDEADBEEF;
    i_wb_ack    = 0;
    sel_wadr    = 0;
    sel_wdata   = 0;
    sel_radr    = 0;
    sel_rdata   = 0;
    sel_wen     = 0;

    // Apply Reset for 62 ns
    i_rst = 1;
    #62;
    i_rst = 0;

    // Wait 2 clock cycles
    #62.5;

    // -------- Test Case 1: External Write Byte [7:0] using sel_brg = 4'b1000
    $display("Test 1: External write byte [7:0] to address 0x01");
    adr_brg   = 10'h001;
    data_brg  = 32'hAABBCCDD;
    stb_brg   = 1;
    wen_brg   = 1;
    sel_brg   = 4'b1000;
    sel_wadr  = 1;
    sel_wdata = 1;
    sel_wen   = 1;
    #31.25;
    stb_brg = 0;
    wen_brg = 0;
    #62.5;

    // -------- Test Case 2: External Read Byte [23:16] with sel_brg = 4'b0010
    $display("Test 2: External read byte [23:16] from address 0x01");
    adr_brg   = 10'h001;
    stb_brg   = 1;
    wen_brg   = 0;
    sel_brg   = 4'b0010;
    sel_radr  = 1;
    sel_rdata = 0;  // From RAM
    #31.25;
    stb_brg = 0;
    #62.5;

    // -------- Test Case 3: Internal write (servile) with sel_wadr = 0
    $display("Test 3: Internal write by servile (no external control)");
    sel_wadr  = 0;
    sel_wdata = 0;
    sel_wen   = 0;
    // Let servile write internally - values would be from core
    #125;

    // -------- Test Case 4: External 32-bit write using sel_brg = 4'b1111
    $display("Test 4: External 32-bit write using burst");
    adr_brg   = 10'h004;
    data_brg  = 32'hCAFEBABE;
    stb_brg   = 1;
    wen_brg   = 1;
    sel_brg   = 4'b1111;
    sel_wadr  = 1;
    sel_wdata = 1;
    sel_wen   = 1;
    repeat (5) #31.25;  // Allow burst writes (bsel cycles through 4 states)
    stb_brg = 0;
    wen_brg = 0;
    #62.5;

    $display("All test cases completed.");
    $finish;
  end

endmodule
