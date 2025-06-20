`timescale 1ns / 1ps

module serv_csr_tb;

  // Parameters
  parameter W = 1;
  parameter B = W - 1;
  parameter CLK_PERIOD = 31.25;

  // DUT signals
  reg i_clk = 1;
  reg i_rst = 1;

  // State inputs
  reg i_trig_irq = 0;
  reg i_en = 0;
  reg i_cnt0to3 = 0;
  reg i_cnt3 = 0;
  reg i_cnt7 = 0;
  reg i_cnt11 = 0;
  reg i_cnt12 = 0;
  reg i_cnt_done = 0;
  reg i_mem_op = 0;
  reg i_mtip = 0;
  reg i_trap = 0;

  // Control inputs
  reg i_e_op = 0;
  reg i_ebreak = 0;
  reg i_mem_cmd = 0;
  reg i_mstatus_en = 0;
  reg i_mie_en = 0;
  reg i_mcause_en = 0;
  reg [1:0] i_csr_source = 2'b00;
  reg i_mret = 0;
  reg i_csr_d_sel = 0;

  // Data inputs/outputs
  reg [B:0] i_rf_csr_out = 0;
  reg [B:0] i_csr_imm = 0;
  reg [B:0] i_rs1 = 0;
  wire [B:0] o_csr_in;
  wire [B:0] o_q;
  wire o_new_irq;
  wire [B:0] d_out;
  wire [B:0] csr_in_o;
  wire [B:0] csr_out_o;
  wire timer_out;

  // Instantiate DUT
  serv_csr #(
    .RESET_STRATEGY("MINI"),
    .W(W)
  ) dut (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_trig_irq(i_trig_irq),
    .i_en(i_en),
    .i_cnt0to3(i_cnt0to3),
    .i_cnt3(i_cnt3),
    .i_cnt7(i_cnt7),
    .i_cnt11(i_cnt11),
    .i_cnt12(i_cnt12),
    .i_cnt_done(i_cnt_done),
    .i_mem_op(i_mem_op),
    .i_mtip(i_mtip),
    .i_trap(i_trap),
    .o_new_irq(o_new_irq),
    .i_e_op(i_e_op),
    .i_ebreak(i_ebreak),
    .i_mem_cmd(i_mem_cmd),
    .i_mstatus_en(i_mstatus_en),
    .i_mie_en(i_mie_en),
    .i_mcause_en(i_mcause_en),
    .i_csr_source(i_csr_source),
    .i_mret(i_mret),
    .i_csr_d_sel(i_csr_d_sel),
    .i_rf_csr_out(i_rf_csr_out),
    .o_csr_in(o_csr_in),
    .i_csr_imm(i_csr_imm),
    .i_rs1(i_rs1),
    .o_q(o_q),
    .d_out(d_out),
    .csr_in_o(csr_in_o),
    .csr_out_o(csr_out_o),
    .timer_out(timer_out)
    
  );

  // Clock generation (32 MHz ? 31.25 ns period)
  always #(CLK_PERIOD / 2) i_clk = ~i_clk;

  // Stimulus
  initial begin
    $display("Starting testbench...");

    // Hold reset high for 62ns
    #62;
    i_rst = 0;
    $display("Released reset at time %t ns", $time);

    // Simulate CSR write operation (minimal)
    @(posedge i_clk);
    i_en = 1;
    i_cnt3 = 1;
    i_mstatus_en = 1;
    i_csr_d_sel = 1;
    i_csr_imm = 1;  // writing 1 to mstatus mie bit
    i_csr_source = 2'b01; // EXT source
    @(posedge i_clk);

    // Simulate interrupt triggering
    i_cnt3 = 0;
    i_mstatus_en = 0;
    i_mie_en = 1;
    i_cnt7 = 1;
    @(posedge i_clk);

    i_cnt7 = 0;
    i_mie_en = 0;
    i_mtip = 1;
    i_trig_irq = 1;
    @(posedge i_clk);

    i_trig_irq = 0;

    // Wait and observe IRQ output
    repeat (5) @(posedge i_clk);

    // Trigger trap handling (set mcause)
    i_trap = 1;
    i_cnt_done = 1;
    i_cnt0to3 = 1;
    i_mcause_en = 1;
    i_e_op = 1;
    @(posedge i_clk);

    i_trap = 0;
    i_cnt_done = 0;
    i_cnt0to3 = 0;
    i_mcause_en = 0;
    i_e_op = 0;

    // Final observation
    repeat (5) @(posedge i_clk);

    $display("Finished simulation at time %t ns", $time);
    $finish;
  end

endmodule
