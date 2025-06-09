`timescale 1ns / 1ps

module serv_immdec_tb;

  reg i_clk = 1;
  reg i_cnt_en = 0;
  reg i_cnt_done = 0;
  reg [3:0] i_immdec_en = 0;
  reg i_csr_imm_en = 0;
  reg [3:0] i_ctrl = 0;
  reg i_wb_en = 0;
  reg [31:7] i_wb_rdt = 0;

  wire [4:0] o_rd_addr;
  wire [4:0] o_rs1_addr;
  wire [4:0] o_rs2_addr;
  wire o_csr_imm;
  wire o_imm;


  serv_immdec #(.SHARED_RFADDR_IMM_REGS(1)) uut (
    .i_clk(i_clk),
    .i_cnt_en(i_cnt_en),
    .i_cnt_done(i_cnt_done),
    .i_immdec_en(i_immdec_en),
    .i_csr_imm_en(i_csr_imm_en),
    .i_ctrl(i_ctrl),
    .o_rd_addr(o_rd_addr),
    .o_rs1_addr(o_rs1_addr),
    .o_rs2_addr(o_rs2_addr),
    .o_csr_imm(o_csr_imm),
    .o_imm(o_imm),
    .i_wb_en(i_wb_en),
    .i_wb_rdt(i_wb_rdt)
  );


  always #(15.625) i_clk = ~i_clk;


  initial begin
    $display("Starting Testbench...");
    $dumpvars(0, serv_immdec_tb);

    
    i_cnt_en = 0;
    i_cnt_done = 0;
    i_immdec_en = 4'b0000;
    i_csr_imm_en = 0;
    i_ctrl = 4'b0000;
    i_wb_en = 0;
    i_wb_rdt = 0;

    
    #(2 * 31.25);

   
    i_wb_rdt = 25'hABCDE1; 
    i_wb_en = 1;
    #(31.25);
    i_wb_en = 0;

    
    i_cnt_en = 1;
    i_immdec_en = 4'b1111;
    i_ctrl = 4'b1010;

    repeat (10) begin
      #(31.25);
    end

    // Finish
    i_cnt_done = 1;
    #(31.25);

    $display("Finished.");
    $finish;
  end

endmodule
