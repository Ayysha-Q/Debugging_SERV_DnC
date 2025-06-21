/*
 * servile_mux.v : Simple Wishbone mux for the servile convenience wrapper.
 *
 * SPDX-FileCopyrightText: 2024 Olof Kindgren <olof.kindgren@gmail.com>
 * SPDX-License-Identifier: Apache-2.0
 */
module servile_mux
  #(parameter [0:0] sim = 1'b0)
  (
   input wire 	      i_clk,
   input wire 	      i_rst,

   input wire [31:0]  i_wb_cpu_adr,
   input wire [31:0]  i_wb_cpu_dat,
   input wire [3:0]   i_wb_cpu_sel,
   input wire 	      i_wb_cpu_we,
   input wire 	      i_wb_cpu_stb,
   output wire [31:0] o_wb_cpu_rdt,
   output wire 	      o_wb_cpu_ack,

   output wire [31:0] o_wb_mem_adr,
   output wire [31:0] o_wb_mem_dat,
   output wire [3:0]  o_wb_mem_sel,
   output wire 	      o_wb_mem_we,
   output wire 	      o_wb_mem_stb,
   input  wire [31:0]  i_wb_mem_rdt,
   input  wire 	      i_wb_mem_ack,

   output wire [31:0]  o_wb_ext_adr,
   output wire [31:0]  o_wb_ext_dat,
   output wire [3:0]   o_wb_ext_sel,
   output wire 	       o_wb_ext_we,
   output wire 	       o_wb_ext_stb,
   input  wire [31:0]  i_wb_ext_rdt,
   input  wire 	       i_wb_ext_ack);

   wire 	      ext = (i_wb_cpu_adr[31:30] != 2'b00); // 1 if 2 MSBs of the address are not equal to zero

   assign o_wb_cpu_rdt = ext ? i_wb_ext_rdt : i_wb_mem_rdt;    // Routing to peripheral if ext is 1 and to memory if ext is 0.
   assign o_wb_cpu_ack = ext ? i_wb_ext_ack : i_wb_mem_ack;

   assign o_wb_mem_adr = i_wb_cpu_adr;
   assign o_wb_mem_dat = i_wb_cpu_dat;
   assign o_wb_mem_sel = i_wb_cpu_sel;
   assign o_wb_mem_we  = i_wb_cpu_we;
   assign o_wb_mem_stb = i_wb_cpu_stb & !ext;

   assign o_wb_ext_adr = i_wb_cpu_adr;
   assign o_wb_ext_dat = i_wb_cpu_dat;
   assign o_wb_ext_sel = i_wb_cpu_sel;
   assign o_wb_ext_we  = i_wb_cpu_we;
   assign o_wb_ext_stb = i_wb_cpu_stb & ext;

endmodule
