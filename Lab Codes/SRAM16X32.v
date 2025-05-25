module DFF (input clk, input d, output reg q);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module Decoder4x16(input [3:0] in, output reg [15:0] out);
    always @(*) begin
        out = 16'b0;
        out[in] = 1'b1;
    end
endmodule

module Mux16x1(input [15:0] in, input [3:0] sel, output out);
    assign out = in[sel];
endmodule

module SRAM16x32(input clk, input [3:0] addr, input [31:0] data_in, input we, output [31:0] data_out);
    reg [31:0] mem [15:0];
    wire [15:0] dec_out;
    Decoder4x16 decoder(addr, dec_out);

    
   
    always @(posedge clk) begin
        if (we) mem[addr] <= data_in;
    end
    assign data_out = mem[addr];
endmodule

module SRAM512x8(input clk, input [8:0] addr, input [7:0] data_in, input we, output [7:0] data_out);
    wire [3:0] row_addr = addr[8:5];
    wire [4:0] col_addr = addr[4:0];
    wire [31:0] sram_out[7:0];
   
    SRAM16x32 s1(clk, row_addr, {24'b0, data_in}, we, sram_out[0]);
    SRAM16x32 s2(clk, row_addr, {24'b0, data_in}, we, sram_out[1]);
    SRAM16x32 s3(clk, row_addr, {24'b0, data_in}, we, sram_out[2]);
    SRAM16x32 s4(clk, row_addr, {24'b0, data_in}, we, sram_out[3]);
    SRAM16x32 s5(clk, row_addr, {24'b0, data_in}, we, sram_out[4]);
    SRAM16x32 s6(clk, row_addr, {24'b0, data_in}, we, sram_out[5]);
    SRAM16x32 s7(clk, row_addr, {24'b0, data_in}, we, sram_out[6]);
    SRAM16x32 s8(clk, row_addr, {24'b0, data_in}, we, sram_out[7]);
   
    assign data_out[0] = sram_out[0][col_addr];
    assign data_out[1] = sram_out[1][col_addr];
    assign data_out[2] = sram_out[2][col_addr];
    assign data_out[3] = sram_out[3][col_addr];
    assign data_out[4] = sram_out[4][col_addr];
    assign data_out[5] = sram_out[5][col_addr];
    assign data_out[6] = sram_out[6][col_addr];
    assign data_out[7] = sram_out[7][col_addr];
endmodule

module SRAM512x8_tb;
    reg clk;
    reg [8:0] addr;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;
   
    SRAM512x8 uut (.clk(clk), .addr(addr), .data_in(data_in), .we(we), .data_out(data_out));
   
    always #5 clk = ~clk;
   
    initial begin
        clk = 0;
        we = 1;
       
        // Write test
        addr = 9'b000000001; data_in = 8'hA5; #10;
        $display("Write: Address=%b, Data=%h", addr, data_in);
        addr = 9'b000000010; data_in = 8'h5A; #10;
        $display("Write: Address=%b, Data=%h", addr, data_in);
        addr = 9'b000001000; data_in = 8'hFF; #10;
        $display("Write: Address=%b, Data=%h", addr, data_in);
       
        we = 0;
       
        // Read test
        addr = 9'b000000001; #10;
        $display("Read: Address=%b, Data=%h", addr, data_out);
        addr = 9'b000000010; #10;
        $display("Read: Address=%b, Data=%h", addr, data_out);
        addr = 9'b000001000; #10;
        $display("Read: Address=%b, Data=%h", addr, data_out);
       
        $stop;
    end
endmodule