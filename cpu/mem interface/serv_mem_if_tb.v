`timescale 1ns / 1ps

module serv_mem_if_tb;

  // Parameters
  localparam W = 8;
  localparam B = W-1;
  localparam CLOCK_PERIOD = 31.25; // 32 MHz clock => 1/32e6 s = 31.25 ns

  // Inputs
  reg i_clk;
  reg [1:0] i_bytecnt;
  reg [1:0] i_lsb;
  reg i_signed;
  reg i_word;
  reg i_half;
  reg i_mdu_op;
  reg [B:0] i_bufreg2_q;

  // Outputs
  wire o_byte_valid;
  wire o_misalign;
  wire [B:0] o_rd;
  wire [3:0] o_wb_sel;

  // Instantiate the Unit Under Test (UUT)
  serv_mem_if #(
    .WITH_CSR(1),
    .W(W),
    .B(B)
  ) uut (
    .i_clk(i_clk),
    .i_bytecnt(i_bytecnt),
    .i_lsb(i_lsb),
    .o_byte_valid(o_byte_valid),
    .o_misalign(o_misalign),
    .i_signed(i_signed),
    .i_word(i_word),
    .i_half(i_half),
    .i_mdu_op(i_mdu_op),
    .i_bufreg2_q(i_bufreg2_q),
    .o_rd(o_rd),
    .o_wb_sel(o_wb_sel)
  );

  // Clock generation: 32 MHz
  initial i_clk = 0;
  always #(CLOCK_PERIOD/2) i_clk = ~i_clk;

  initial begin
    $display("Starting testbench...");
    $dumpfile("serv_mem_if_tb.vcd");
    $dumpvars(0, serv_mem_if_tb);

    // Test 1: Word access aligned
    i_bytecnt     = 2'b00;
    i_lsb         = 2'b00;
    i_signed      = 1'b0;
    i_word        = 1'b1;
    i_half        = 1'b0;
    i_mdu_op      = 1'b0;
    i_bufreg2_q   = 8'hAA;
    #100;

    // Test 2: Half-word access aligned
    i_bytecnt     = 2'b00;
    i_lsb         = 2'b10;
    i_signed      = 1'b0;
    i_word        = 1'b0;
    i_half        = 1'b1;
    i_bufreg2_q   = 8'h55;
    #100;

    // Test 3: Byte access
    i_bytecnt     = 2'b00;
    i_lsb         = 2'b01;
    i_signed      = 1'b0;
    i_word        = 1'b0;
    i_half        = 1'b0;
    i_bufreg2_q   = 8'h0F;
    #100;

    // Test 4: Misaligned word access
    i_bytecnt     = 2'b00;
    i_lsb         = 2'b01;
    i_signed      = 1'b0;
    i_word        = 1'b1;
    i_half        = 1'b0;
    i_bufreg2_q   = 8'hF0;
    #100;

    // Test 5: Signed load with negative MSB
    i_bytecnt     = 2'b00;
    i_lsb         = 2'b00;
    i_signed      = 1'b1;
    i_word        = 1'b0;
    i_half        = 1'b0;
    i_bufreg2_q   = 8'b10000000; // MSB = 1
    #100;

    $display("Testbench complete.");
    $finish;
  end

endmodule
