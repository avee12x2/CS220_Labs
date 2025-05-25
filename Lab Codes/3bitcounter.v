module bit_3_counter(clk,rst,out);

parameter W=32; parameter Y=32; 
parameter S0=4'd0;
parameter S1=4'd2;
parameter S2=4'd5;
parameter S3=4'd3;
parameter S4=4'd4;

input clk,rst;
output [Y-1:0] out;

reg [3:0] pstate,nstate;

initial begin
pstate <= 0;
end

always@(posedge clk) begin
if(rst) pstate<=S0;
else pstate<=nstate;
end

always@(pstate) begin
case(pstate)
S0: nstate <= S1;
S1: nstate <= S2;
S2: nstate <= S3;
S3: nstate <= S4;
S4: nstate <= S0;
default: nstate<=S0;
endcase
end

assign out = pstate;

endmodule