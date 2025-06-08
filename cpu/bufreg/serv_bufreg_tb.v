`timescale 1ns/1ps

module serv_bufreg_tb;


  localparam CLK_PERIOD = 31;  // 32MHz clock => 31.25ns, approximated


  localparam MDU = 0;
  localparam W = 1;
  localparam B = W-1;


  reg i_clk;
  reg i_cnt0;
  reg i_cnt1;
  reg i_en;
  reg i_init;
  reg i_mdu_op;
  reg i_rs1_en;
  reg i_imm_en;
  reg i_clr_lsb;
  reg i_sh_signed;
  reg [B:0] i_rs1;
  reg [B:0] i_imm;


  wire [1:0] o_lsb;
  wire [B:0] o_q;
  wire [31:0] o_dbus_adr;
  wire [31:0] o_ext_rs1;
  

  serv_bufreg #(
    .MDU(MDU),
    .W(W)
  ) dut (
    .i_clk(i_clk),
    .i_cnt0(i_cnt0),
    .i_cnt1(i_cnt1),
    .i_en(i_en),
    .i_init(i_init),
    .i_mdu_op(i_mdu_op),
    .o_lsb(o_lsb),
    .i_rs1_en(i_rs1_en),
    .i_imm_en(i_imm_en),
    .i_clr_lsb(i_clr_lsb),
    .i_sh_signed(i_sh_signed),
    .i_rs1(i_rs1),
    .i_imm(i_imm),
    .o_q(o_q),
    .o_dbus_adr(o_dbus_adr),
    .o_ext_rs1(o_ext_rs1)
  );


  always #(CLK_PERIOD/2) i_clk = ~i_clk;

  initial begin

    i_clk = 1;
    i_cnt0 = 0;
    i_cnt1 = 0;
    i_en = 0;
    i_init = 0;
    i_mdu_op = 0;
    i_rs1_en = 0;
    i_imm_en = 0;
    i_clr_lsb = 0;
    i_sh_signed = 0;
    i_rs1 = 0;
    i_imm = 0;


    #100;


    i_rs1 = 1'b1;
    i_imm = 1'b1;
    i_rs1_en = 1;
    i_imm_en = 1;
    i_en = 1;
    i_init = 1;
    i_cnt0 = 1;
    i_cnt1 = 0;
    #CLK_PERIOD;

    #80 i_init = 0;
    #100 i_init = 1;
    #80 i_init = 0;
    i_cnt0 = 0;
    i_cnt1 = 0;
    i_rs1_en = 0;
    i_imm_en = 0;


    repeat (35) begin
      #CLK_PERIOD;
    end


    i_sh_signed = 1;
    i_en = 1;
    i_init = 1;
    i_rs1 = 1'b0;
    i_imm = 1'b0;
    i_rs1_en = 1;
    i_imm_en = 1;
    i_cnt0 = 1;
    #CLK_PERIOD;

    i_init = 1;
    i_rs1_en = 0;
    i_imm_en = 0;
    

    repeat (10) begin
      #CLK_PERIOD;
    end
    
    $display("Simulation complete.");
    $finish;
  end

endmodule
