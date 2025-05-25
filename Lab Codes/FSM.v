`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2022 08:42:08
// Design Name: 
// Module Name: FSM_template
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


module FSM_template(ctrl,clk,rst,out);
parameter W=32;
parameter Y=32;

parameter S0=4'd0;
parameter S1=4'd1;
parameter S2=4'd2;
parameter S3=4'd3;

input [W-1:0] ctrl; // 
input clk,rst;
output reg [Y-1:0] out;

reg [3:0] pstate,nstate;
always@(posedge clk)
begin
if(rst)
    pstate<=S0;
else
    pstate<=nstate;
end


always@(ctrl,pstate)
begin
case(pstate)
    S0: nstate<=S1;
    S1: begin 
            if(ctrl==32'd5)
                nstate<=S2;
            else
                nstate<=S3;
        end
    S2:begin 
            if(ctrl==32'd7)
                nstate<=S1;
            else
                nstate<=S3;
        end    
    S3:begin 
            if(ctrl==32'd9)
                nstate<=S0;
            else
                nstate<=S3;
       end
    default: nstate<=S0; 
   endcase
end

always@(pstate,ctrl)
begin
case(pstate)
    S0: out<=32'd0;
    S1: begin 
            if(ctrl==32'd5)
                out<=2'd2;
            else
                out<=2'd3;
        end
    S2:out<=32'd9;
    S3:begin 
            if(ctrl==32'd9)
                out<=32'd6;
            else
                out<=32'd11;
       end
    default: out<=0; 
   endcase
end




endmodule
