`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2024 23:32:42
// Design Name: 
// Module Name: simple_modular_adder
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


module simple_modular_adder(a,b,p,clk,rst,out,done);


input [254:0] a,b;
input clk,rst;
output [254:0] out;
input [254:0] p;
wire [255:0] add_out,sub_out;
output done;
wire sign;

//assign prime=256'h7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed;

//choose nearest eighth and third multiple of (WB+4)*16

reg [255:0] reg_a, reg_b;

wire [63:0] sum_3,sum_4;
wire cout_3,cout_4;
reg cin_3,cin_4,rst_r,rst_rr;

reg [255:0] reg_sum_3,reg_sum_4,reg_p;
wire sum_4_en,sum_3_en;
reg [4:0] count;


wire done;
//assign out={36'd0,final_result[752:0]};







always@(posedge clk)
begin
if(rst)
count<=0;
else if(count==4'd6)
count<=count;
else
count<=count+1;
end





assign done=(count==4'd5)?1:0;
assign sum_3_en=(count<4'd4)?1:0;
assign sum_4_en=(count<4'd5)?1:0;


always@(posedge clk)
begin
if(rst)
begin
reg_a<={1'd0,a};reg_b<={1'd0,b};
cin_3<=1'd0;
end
else
begin
reg_a<={64'd0,reg_a[255:64]};reg_b<={64'd0,reg_b[255:64]};
cin_3<=cout_3;
end
end


always@(posedge clk)
begin
if(rst)
begin
reg_sum_3<=0;
end
else if(sum_3_en)
begin
reg_sum_3<={sum_3,reg_sum_3[255:64]};
end
else
reg_sum_3<=reg_sum_3;
end

always@(posedge clk)
begin
if(rst)
begin
reg_sum_4<=0;
end
else if(sum_4_en)
begin
reg_sum_4<={sum_4,reg_sum_4[255:64]};
end
else
reg_sum_4<=reg_sum_4;
end

always@(posedge clk)
begin
rst_r<=rst;
rst_rr<=rst_r;
end

always@(posedge clk)
begin
if(rst|rst_r)
begin
reg_p<=p;
cin_4<=1'd0;
end
else 
begin
reg_p<={64'h0,reg_p[255:64]};
cin_4<=cout_4;
end
end







simple_adder_128bit #(.W(64)) add2(reg_a[63:0],reg_b[63:0],cin_3,sum_3,cout_3);

simple_subtractor #(.W(64)) sub(reg_sum_3[255:192],reg_p[63:0],cin_4,sum_4,cout_4);

/*always@(*)
begin
if(sel==0)
sign<=reg_sum_4[767];
else
sign<=reg_sum_3[767];
end*/

assign sign=cout_4;

assign add_out=reg_sum_3[255:0];
assign sub_out=reg_sum_4[255:0];

assign out=(sign)?add_out:sub_out;

endmodule




