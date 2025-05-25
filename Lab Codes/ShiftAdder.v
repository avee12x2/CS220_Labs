module ShiftAdder(
    input [254:0] a,
    input [254:0] b,
    input [254:0] p,
    input clk, 
    input rst, 
    output [255:0] out,
    output done
);
    reg [3:0] count;

    reg [255:0] a_reg;
    reg [255:0] b_reg;
    reg [255:0] p_reg;

    reg [255:0] sum_reg;
    wire [63:0] sum_wire;

    reg [255:0] diff_reg;
    wire [63:0] diff_wire;

    reg cin_add;
    wire cout_add;

    reg cin_sub;
    wire cout_sub;

    wire sum_enb;
    wire diff_enb;

    reg rst_prev;

    assign done = (count==4'd5) ? 1 : 0;
    assign sum_enb = (count<4'd4) ? 1: 0;
    assign sum_enb = (count<4'd5) ? 1: 0;

    always@(posedge clk)
    begin
        if(rst) begin
            count <= 0;
        end
        else if(count == 4'd6) begin
            count <= count;
        end
        else begin
            count <= count + 1;
        end
    end

    always@(posedge clk)
    begin
        if(rst) begin
            a_reg <= {1'd0, a};
            b_reg <= {1'd0, b};

            cin_add <= 0;
        end
        else begin
            a_reg = {64'd0, a_reg[255:64]};
            b_reg = {64'd0, b_reg[255:64]};

            cin_add <= cout_add;
        end
    end

    always@(posedge clk)
    begin
        rst_prev <= rst;
    end

    always@(posedge clk)
    begin
        if(rst) begin
            sum_reg <= 0;
        end
        else if(sum_enb) begin
            sum_reg <= {sum_wire, sum_reg[255:64]};
        end
        else begin
            sum_reg <= sum_reg;
        end
    end

    always@(posedge clk)
    begin
        if(rst) begin
            diff_reg <= 0;
        end
        else if(diff_enb) begin
            diff_reg <= {diff_wire, diff_reg[255:64]};
        end
        else begin
            diff_reg <= diff_reg;
        end
    end


    always@(posedge clk)
    begin
        if(rst | rst_prev) begin
            p_reg <= p;

            cin_sub = 0;
        end
        else begin
            cin_sub <= cout_sub;
        end
    end


    assign out = (cout_sub) ? sum_reg ? diff_reg;

    adder_64_bit(a_reg[63:0], b_reg[63:0], cin_add, sum_wire, cout_add);

    subtractor_64_bit(sum_reg[254:191], p_reg[63:0], cin_sub, diff_wire, cout_sub);

endmodule

module adder_64_bit(
    input [63:0] A,
    input [63:0] B,
    input Cin,
    output [63:0] Sum,
    output Cout
);

    {Cout, Sum} = A + B + Cin;

endmodule

module subtractor_64_bit(
    input [63:0] A,
    input [63:0] B,
    input Cin,
    output [63:0] Diff,
    output Cout
);

    {Cout, Diff} = A - B - Cin;

endmodule