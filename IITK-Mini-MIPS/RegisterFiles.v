module GPR(
    input clk, reset,
    input [4:0] read1, read2, write,
    input [31:0] write_data,
    input write_enable,
    output [31:0] read_data1, read_data2
);

    reg [31:0] registers [0:31]; // 32 registers of 32 bits each

    assign read_data1 = (reset) ? 32'b0 : registers[read1];
    assign read_data2 = (reset) ? 32'b0 : registers[read2];
    
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers to 0
            
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (write_enable && write != 5'b0) begin
            // Write data to the specified register if write_enable is high and write is not zero register
            registers[write] <= write_data;
        end
    end

endmodule


module FPR(
    input clk, reset,
    input [4:0] read1, read2, write,
    input [31:0] write_data,
    input write_enable,
    output [31:0] read_data1, read_data2
);

    reg [31:0] registers [0:31]; // 32 registers of 32 bits each

    assign read_data1 = (reset) ? 32'b0 : registers[read1];
    assign read_data2 = (reset) ? 32'b0 : registers[read2];

    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers to 0
            
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (write_enable && write != 5'b0) begin
            // Write data to the specified register if write_enable is high and write is not zero register
            registers[write] <= write_data;
        end
    end

endmodule