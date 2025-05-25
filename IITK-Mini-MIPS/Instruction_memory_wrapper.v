`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 05:37:30 PM
// Design Name: 
// Module Name: Instruction_memory_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Instruction_memory_wrapper(a,d,dpra,clk,we,dpo);
    
    input [9:0] a,dpra;
    input clk,we;
    output [31:0] dpo;
    input [31:0] d; 
     
    dist_mem_gen_1 your_instance_name (
      .a(a),        // Write Address
      .d(d),        // Data to Write
      .dpra(dpra),  // Read Address
      .clk(clk),    // clk
      .we(we),      // Write enable
      .dpo(dpo)    // Data read from dpra address
    );
endmodule
