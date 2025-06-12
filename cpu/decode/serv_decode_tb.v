`timescale 1ns/1ps
module serv_decode_tb;

  // parameters
  localparam CLK_FREQ_HZ = 32_000_000;
  localparam PERIOD_NS   = 1_000_000_000 / CLK_FREQ_HZ; // ?31.25 ns

  reg         clk = 1;
  reg [31:2]  i_wb_rdt = 30'b0;
  reg         i_wb_en  = 0;

  wire        o_sh_right, o_bne_or_bge, o_cond_branch;
  wire        o_e_op, o_ebreak, o_branch_op, o_shift_op, o_slt_or_branch;
  wire        o_rd_op, o_two_stage_op, o_dbus_en, o_mdu_op;
  wire [2:0]  o_ext_funct3;
  wire        o_bufreg_rs1_en, o_bufreg_imm_en, o_bufreg_clr_lsb, o_bufreg_sh_signed;
  wire        o_ctrl_jal_or_jalr, o_ctrl_utype, o_ctrl_pc_rel, o_ctrl_mret;
  wire        o_alu_sub;
  wire [1:0]  o_alu_bool_op;
  wire        o_alu_cmp_eq, o_alu_cmp_sig;
  wire [2:0]  o_alu_rd_sel;
  wire        o_mem_signed, o_mem_word, o_mem_half, o_mem_cmd;
  wire        o_csr_en;
  wire [1:0]  o_csr_addr, o_csr_source;
  wire        o_csr_mstatus_en, o_csr_mie_en, o_csr_mcause_en, o_csr_d_sel, o_csr_imm_en, o_mtval_pc;
  wire [3:0]  o_immdec_ctrl, o_immdec_en;
  wire        o_op_b_source, o_rd_mem_en, o_rd_csr_en, o_rd_alu_en;
 

  serv_decode #(.PRE_REGISTER(1), .MDU(1)) dut (
    .clk(clk),
    .i_wb_rdt(i_wb_rdt),
    .i_wb_en(i_wb_en),
    .o_sh_right(o_sh_right), 
    .o_bne_or_bge(o_bne_or_bge), 
    .o_cond_branch(o_cond_branch),
    .o_e_op(o_e_op), 
    .o_ebreak(o_ebreak), 
    .o_branch_op(o_branch_op),
    .o_shift_op(o_shift_op), 
    .o_slt_or_branch(o_slt_or_branch),
    .o_rd_op(o_rd_op), 
    .o_two_stage_op(o_two_stage_op), 
    .o_dbus_en(o_dbus_en),
    .o_mdu_op(o_mdu_op), 
    .o_ext_funct3(o_ext_funct3),
    .o_bufreg_rs1_en(o_bufreg_rs1_en), 
    .o_bufreg_imm_en(o_bufreg_imm_en),
    .o_bufreg_clr_lsb(o_bufreg_clr_lsb), 
    .o_bufreg_sh_signed(o_bufreg_sh_signed),
    .o_ctrl_jal_or_jalr(o_ctrl_jal_or_jalr), 
    .o_ctrl_utype(o_ctrl_utype),
    .o_ctrl_pc_rel(o_ctrl_pc_rel), 
    .o_ctrl_mret(o_ctrl_mret),
    .o_alu_sub(o_alu_sub), 
    .o_alu_bool_op(o_alu_bool_op),
    .o_alu_cmp_eq(o_alu_cmp_eq), 
    .o_alu_cmp_sig(o_alu_cmp_sig),
    .o_alu_rd_sel(o_alu_rd_sel),
    .o_mem_signed(o_mem_signed), 
    .o_mem_word(o_mem_word),
    .o_mem_half(o_mem_half), 
    .o_mem_cmd(o_mem_cmd),
    .o_csr_en(o_csr_en), 
    .o_csr_addr(o_csr_addr),
    .o_csr_mstatus_en(o_csr_mstatus_en), 
    .o_csr_mie_en(o_csr_mie_en),
    .o_csr_mcause_en(o_csr_mcause_en), 
    .o_csr_source(o_csr_source),
    .o_csr_d_sel(o_csr_d_sel), 
    .o_csr_imm_en(o_csr_imm_en),
    .o_mtval_pc(o_mtval_pc),
    .o_immdec_ctrl(o_immdec_ctrl), 
    .o_immdec_en(o_immdec_en),
    .o_op_b_source(o_op_b_source),
    .o_rd_mem_en(o_rd_mem_en), 
    .o_rd_csr_en(o_rd_csr_en),
    .o_rd_alu_en(o_rd_alu_en)
  );

  // Clock generation: 32 MHz ? 31.25 ns
  always #(PERIOD_NS/2) clk = ~clk;

  initial begin
    $display("Starting serv_decode testbench...");
    // Reset and idle
    i_wb_en = 0; i_wb_rdt = 0;
    #(PERIOD_NS*2);

    // Apply a few instruction encodings
    // Example: ADDI (opcode=00100, funct3=000)
    i_wb_en = 1;
    i_wb_rdt = {5'b00100, 5'b0, 3'b000, 12'h123, 2'b00}; // imm+funct3+rs1/rd filler
    #(PERIOD_NS);

    // Example: BEQ (opcode[6:2]=11000, funct3=000)
    i_wb_rdt = {5'b11000, 5'b0, 3'b000, 12'h0, 2'b00};
    #(PERIOD_NS);

    // CSR: MRET (opcode=11100, funct3=000, op21=1, op20=0)
    i_wb_rdt = {5'b11100, 1'b0, 1'b1, 1'b0, 3'b000, 12'h0, 2'b00};
    #(PERIOD_NS);

    // Done
    i_wb_en = 0;
    #(PERIOD_NS*2);
    $display("Finished.");
    $stop;
  end

endmodule
