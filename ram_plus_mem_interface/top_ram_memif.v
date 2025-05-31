`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module top_ram_memif(

    input wire clk_top,
    input wire rst_top,
    input wire [7:0]  i_raddr_top,
    input wire        i_ren_top,
    input wire [7:0]  i_waddr_top,
    input wire [9:2]  i_wb_adr_top,
    input wire [31:0] i_wb_dat_top,
    input wire [3:0]  i_wb_sel_top,
    input wire i_wb_stb_top,
    input wire i_wb_we_top,
    input wire [7:0] i_wdata_top,
    //input wire sel_wen_top,
    input wire i_wen_top,
    
    output wire [7:0] o_rdata_top,
    output wire o_wb_ack_top,
    output wire [31:0] o_wb_rdt_top
    );
    
    parameter memfile = "";
    parameter memsize = 1024;
    parameter WITH_CSR = 1;
    localparam regs = 32+WITH_CSR*4;
    
    
    //// -- Interanls -- ////
    wire [9:0] waddr_top;
    wire [9:0] wdata_top;
    wire [9:0] raddr_top;
    wire       wen_top;
    wire [7:0] rdata_top;
    wire ren_top;
    
    
    
    serving_ram
        #(.memfile (memfile),
          .depth   (memsize))
      ram
        (// Wishbone interface
         .i_clk (clk_top),
         .i_rst (rst_top),
         .i_waddr  (waddr_top),
         .i_wdata  (wdata_top),
         .i_wen    (wen_top),
         .i_raddr  (raddr_top),
         .o_rdata  (rdata_top),
         .i_ren    (ren_top)
         );
         
     
     
     
     servile_rf_mem_if
        #(.depth   (memsize),
          .rf_regs (regs))
      rf_mem_if
        (// Wishbone interface
         .i_clk (clk_top),
         .i_rst (rst_top),
   
         .i_waddr  (i_waddr_top),
         .i_wdata  (i_wdata_top),

         .i_raddr  (i_raddr_top),
         .o_rdata  (o_rdata_top),
         .i_ren    (i_ren_top),
   
         .o_sram_waddr (waddr_top),
         .o_sram_wdata (wdata_top),
         .o_sram_wen   (wen_top),
         .o_sram_raddr (raddr_top),
         .i_sram_rdata (rdata_top),
         //.sel_wen      (sel_wen_top),
         .i_wen        (i_wen_top),
         .o_sram_ren   (ren_top),
   
         .i_wb_adr (i_wb_adr_top),
         .i_wb_stb (i_wb_stb_top),
         .i_wb_we  (i_wb_we_top) ,
         .i_wb_sel (i_wb_sel_top),
         .i_wb_dat (i_wb_dat_top),
         .o_wb_rdt (o_wb_rdt_top),
         .o_wb_ack (o_wb_ack_top));
   
endmodule
