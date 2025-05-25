module Bank (
    input clk,
    input rst,
    input [3:0] row_add,       // 4-bit Row Address (16 rows)
    input [4:0] col_add,       // 5-bit Column Address (32 columns)
    input bank_select,         // Enables the bank
    input write_enable,        // Write Enable
    input [3:0] data_in,       // 4-bit Input Data
    output reg [3:0] data_out  // 4-bit Output Data
);

    reg [3:0] memory [0:15][0:31]; // 16x32 array of 4-bit registers
    reg [15:0] row_decoder_out;     // One-hot row selection
    reg [31:0] col_decoder_out;     // One-hot column selection

    // First-Level Decoding: Row Selection (One-Hot Encoding)
    always @(*) begin
        row_decoder_out = 16'b0000000000000001 << row_add;
    end

    // Second-Level Decoding: Column Selection (One-Hot Encoding)
    always @(*) begin
        col_decoder_out = 32'b00000000000000000000000000000001 << col_add;
    end

    // Read/Write Operation
    always @(posedge clk or posedge rst) begin
        if (bank_select) begin
            if (rst) begin
                data_out <= 4'b0000;
            end
            else if (write_enable) begin
                // Write Operation: Store data at selected row and column
                memory[row_add][col_add] <= data_in;
            end 
            else begin
                // Read Operation: Retrieve data from selected row and column
                data_out <= memory[row_add][col_add];
            end
        end
        else begin
            data_out <= 4'bzzzz;
        end
    end

endmodule

module Decoder4to16 (
    input [3:0] in,      // 4-bit input
    input en,            // Enable signal
    output reg [15:0] out // 16-bit one-hot output
);

always @(*) begin
    if (en) 
        out = 16'b0000000000000001 << in; // One-hot encoding using shift
    else
        out = 16'b0000000000000000; // Disabled output
end

endmodule


module Chip(
    input clk,
    input rst,
    input [12:0] addr,
    input write_enable,
    input [3:0] data_in,
    output [3:0] data_out
);

    wire [15:0] bank_select;


    Decoder4to16 dec_inst(addr[6:3], 1'b1, bank_select);

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            Bank bank_inst (
                .clk(clk),
                .rst(rst),
                .row_add(addr[12:9]),
                .col_add({addr[8:7], addr[2:0]}),
                .bank_select(bank_select[i]),
                .write_enable(write_enable),
                .data_in(data_in),
                .data_out(data_out)
            );
        end
    endgenerate
endmodule

module DRAM(
    input clk,
    input rst,
    input [12:0] addr,
    input write_enable,
    input [63:0] data_in,
    output [63:0] data_out
);

    reg [2:0] count;
    reg [12:0] addr_reg;

    always @(posedge clk or posedge rst)
        if(rst) begin
            count <= 3'b000;
            addr_reg <= addr;
        end
        else if(count<3'b111) begin
            count <= count +1;
            addr_reg <= addr_reg + 1;
        end
        else begin
            count <= count;
            addr_reg <= addr_reg;
        end

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            Chip chip_inst(
                .clk(clk),
                .rst(rst),
                .addr(addr_reg),
                .write_enable(write_enable),
                .data_in(data_in[4*i+3: 4*i]),
                .data_out(data_out[4*i+3: 4*i])
            );
        end
    endgenerate
endmodule