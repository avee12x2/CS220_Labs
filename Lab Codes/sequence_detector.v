module sequence_detector(in,clk,rst,out);

parameter W=32; parameter Y=32; 
parameter S0=4'd0;
parameter S1=4'd1;
parameter S2=4'd2;
parameter S3=4'd3;
parameter S4=4'd4;
parameter S5=4'd5;
parameter S6=4'd6;

input in,clk,rst;
output reg out;

reg [3:0] pstate,nstate;

initial begin
    pstate <= 0;
end

always@(posedge clk) begin
    if(rst) pstate<=S0;
    else pstate<=nstate;
end

always@(pstate or in) begin
    if(in==0) begin
        case(pstate)
            S0: nstate <= S1;
            S1: nstate <= S2;
            S2: nstate <= S3;
            S3: nstate <= S3;
            S4: nstate <= S1;
            S5: nstate <= S1;
            S6: nstate <= S1;
            default: nstate<=S0;
        endcase
    end
    else begin
        case(pstate)
            S0: nstate <= S4;
            S1: nstate <= S4;
            S2: nstate <= S4;
            S3: nstate <= S4;
            S4: nstate <= S5;
            S5: nstate <= S6;
            S6: nstate <= S6;
            default: nstate <= S0;
        endcase
    end
end

always@(pstate) begin
    case(pstate)
        S3: out <= 1;
        S6: out <= 1;
        default: out <= 0;
    endcase
end

endmodule