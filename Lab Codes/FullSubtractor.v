module full_subtractor_structural_32_bit  (
    input [31:0] A,
    input [31:0] B,
    output [31:0] D,
    output Bout
);
    wire [32:0] Bin;

    assign Bin[0] = 0;

    assign Bout = Bin[32];

    genvar i;

    generate
    for(i=0; i<32; i++) begin : sub
        full_subtractor_structural_one_bit subtr(A[i], B[i], Bin[i], D[i], Bin[i+1]);
    end
    endgenerate

endmodule





module full_subtractor_structural_one_bit (
    input wire A,
    input wire B,
    input wire Bin,
    output wire D,
    output wire Bout
);

    wire notA, notAxorB, AxorB;
    wire and1, and2;

    xor xor1(AxorB, A, B);    
    xor xor2(D, AxorB, Bin);      

    not not1(notA, A);            
    not not2(notAxorB, AxorB);    

    and and1_gate(and1, notA, B);   
    and and2_gate(and2, notAxorB, Bin); 

    or or1(Bout, and1, and2);

endmodule

