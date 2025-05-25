// ALU Module: two 32-bit inputs, one 32-bit result, one branch output.
module ALU (
    input  [31:0] A,      // First operand
    input  [31:0] B,      // Second operand (or immediate, or shift amount in lower 5 bits)
    input  [4:0]  ALUOp,  // ALU operation control (provided by control unit)
    output reg [31:0] result, // 32-bit ALU result
    output reg branch         // Branch condition output (1 if branch condition satisfied)
);

  // Define ALU operation encodings
  localparam ALU_ADD   = 5'b00000;  // Addition (for add, addi, addu, addiu, lw, sw, jr - other register = 0)
  localparam ALU_SUB   = 5'b00001;  // Subtraction (for sub, subu)
  localparam ALU_AND   = 5'b00010;  // Bitwise AND (for and, andi)
  localparam ALU_OR    = 5'b00011;  // Bitwise OR (for or, ori)
  localparam ALU_XOR   = 5'b00100;  // Bitwise XOR (for xor, xori)
  localparam ALU_NOT   = 5'b00101;  // Bitwise NOT (for not)
  localparam ALU_SLL   = 5'b00110;  // Shift left logical (sll, sla)
  localparam ALU_SRL   = 5'b00111;  // Shift right logical (srl)
  localparam ALU_SRA   = 5'b01000;  // Shift right arithmetic (sra)
  
  // Branch comparisons
  localparam ALU_BEQ   = 5'b01001;  // Branch if equal
  localparam ALU_BNE   = 5'b01010;  // Branch if not equal
  localparam ALU_BGT   = 5'b01011;  // Branch if greater than (signed)
  localparam ALU_BGTE   = 5'b01100;  // Branch if greater than or equal (signed)
  localparam ALU_BLE   = 5'b01101;  // Branch if less than (signed)
  localparam ALU_BLEQ   = 5'b01110;  // Branch if less than or equal (signed)
  localparam ALU_BLEU  = 5'b01111;  // Branch if less than (unsigned)
  localparam ALU_BGTU  = 5'b10000;  // Branch if greater than (unsigned)
  
  // Set instructions
  localparam ALU_SLT   = 5'b10001;  // Set on less than (signed): result = 1 if (A < B) (slt, slti)
  localparam ALU_SEQ   = 5'b10010;  // Set on equal: result = 1 if (A == B) (seq)

  //LUI
  localparam ALU_LUI   = 5'b10011;  // Left shift B by 16 and make upper 16 digits of A same as B

  // Combinational ALU logic
  always @(*) begin
    // Default outputs
    result = 32'b0;
    branch = 1'b0;
    
    case (ALUOp)
      // Arithmetic operations:
      ALU_ADD:     result = A + B;
      ALU_SUB:     result = A - B;
      
      // Bitwise logic:
      ALU_AND:     result = A & B;
      ALU_OR:      result = A | B;
      ALU_XOR:     result = A ^ B;
      ALU_NOT:     result = ~A; // ignoring B
      
      // Shifts (note: shift amount is taken from B[4:0]):
      ALU_SLL:     result = A << B[4:0];
      ALU_SRL:     result = A >> B[4:0];         // logical shift right
      ALU_SRA:     result = $signed(A) >>> B[4:0]; // arithmetic shift right
      
      // Branch conditions (result is don't care, branch signal indicates condition):
      ALU_BEQ:     branch = (A == B);
      ALU_BNE:     branch = (A != B);
      ALU_BGT:     branch = ($signed(A) > $signed(B));
      ALU_BGTE:    branch = ($signed(A) >= $signed(B));
      ALU_BLE:     branch = ($signed(A) < $signed(B));
      ALU_BLEQ:    branch = ($signed(A) <= $signed(B));
      ALU_BLEU:    branch = (A < B);   // unsigned comparison
      ALU_BGTU:    branch = (A > B);   // unsigned comparison
      
      // Set instructions:
      ALU_SLT:     result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
      ALU_SEQ:     result = (A == B) ? 32'b1 : 32'b0;

      //LUI
      ALU_LUI:     result = {B[15:0], A[15:0]};
      
      default: begin
        // For any undefined ALUOp, keep outputs 0.
        result = 32'b0;
        branch = 1'b0;
      end
    endcase
  end

endmodule


// MAU Module: two 32-bit inputs, one 32-bit hi, one 32-bit lo output.
module MAU (
    input reset,

    input [31:0] A,
    input [31:0] B,
    input [1:0] MAUOp,          // 2'b00: madd, 2'b01: maddu, 2'b10: mul
    input MAUen,                // Enable signal for the operation

    output reg [31:0] hi,
    output reg [31:0] lo
);
    reg [63:0] product;
    reg [63:0] accumulator;

    always @(*) begin
        if (reset) begin
            hi <= 32'b0;
            lo <= 32'b0;
        end else if (MAUen) begin
            case (MAUOp)
                2'b00: begin // madd (signed)
                    product = $signed(A) * $signed(B);
                    accumulator = {hi, lo} + product;
                    hi <= accumulator[63:32];
                    lo <= accumulator[31:0];
                end
                2'b01: begin // maddu (unsigned)
                    product = A * B;
                    accumulator = {hi, lo} + product;
                    hi <= accumulator[63:32];
                    lo <= accumulator[31:0];
                end
                2'b10: begin // mul (signed), no accumulation
                    product = $signed(A) * $signed(B);
                    hi <= product[63:32];
                    lo <= product[31:0];
                end
                default: begin
                end
            endcase
        end
    end
endmodule



module FPU_Add (
    input  [31:0] A,    // f1
    input  [31:0] B,    // f2
    output reg [31:0] result
);
  // Internal signals for decoding the IEEE-754 fields
  reg         signA, signB, signRes;
  reg  [7:0]  expA, expB, expRes;
  reg  [22:0] fracA, fracB;
  reg  [23:0] normA, normB;
  reg  [24:0] mantA, mantB, mantSum, mantRes;
  reg  [4:0]  leadingZeros;
  integer     shift;

  // Function to count leading zeros in a 24-bit value
  function [4:0] countLeadingZeros;
    input [24:0] value;
    begin
      casex (value)
        25'b1xxxxxxxxxxxxxxxxxxxxxxxx: countLeadingZeros = 5'd0;
        25'b01xxxxxxxxxxxxxxxxxxxxxx: countLeadingZeros = 5'd1;
        25'b001xxxxxxxxxxxxxxxxxxxxx: countLeadingZeros = 5'd2;
        25'b0001xxxxxxxxxxxxxxxxxxxx: countLeadingZeros = 5'd3;
        25'b00001xxxxxxxxxxxxxxxxxxx: countLeadingZeros = 5'd4;
        25'b000001xxxxxxxxxxxxxxxxxx: countLeadingZeros = 5'd5;
        25'b0000001xxxxxxxxxxxxxxxxx: countLeadingZeros = 5'd6;
        25'b00000001xxxxxxxxxxxxxxxx: countLeadingZeros = 5'd7;
        25'b000000001xxxxxxxxxxxxxxx: countLeadingZeros = 5'd8;
        25'b0000000001xxxxxxxxxxxxxx: countLeadingZeros = 5'd9;
        25'b00000000001xxxxxxxxxxxxx: countLeadingZeros = 5'd10;
        25'b000000000001xxxxxxxxxxxx: countLeadingZeros = 5'd11;
        25'b0000000000001xxxxxxxxxxx: countLeadingZeros = 5'd12;
        25'b00000000000001xxxxxxxxxx: countLeadingZeros = 5'd13;
        25'b000000000000001xxxxxxxxx: countLeadingZeros = 5'd14;
        25'b0000000000000001xxxxxxxx: countLeadingZeros = 5'd15;
        25'b00000000000000001xxxxxxx: countLeadingZeros = 5'd16;
        25'b000000000000000001xxxxxx: countLeadingZeros = 5'd17;
        25'b0000000000000000001xxxxx: countLeadingZeros = 5'd18;
        25'b00000000000000000001xxxx: countLeadingZeros = 5'd19;
        25'b000000000000000000001xxx: countLeadingZeros = 5'd20;
        25'b0000000000000000000001xx: countLeadingZeros = 5'd21;
        25'b00000000000000000000001x: countLeadingZeros = 5'd22;
        25'b000000000000000000000001: countLeadingZeros = 5'd23;
        default: countLeadingZeros = 5'd24; // All zero
      endcase
    end
  endfunction

  always @(*) begin
    // Decode A and B
    signA = A[31]; expA = A[30:23]; fracA = A[22:0]; normA = {1'b1, fracA};
    signB = B[31]; expB = B[30:23]; fracB = B[22:0]; normB = {1'b1, fracB};

    // Align exponents
    if(expA >= expB) begin
      shift = expA - expB;
      mantA = {1'b0, normA};
      mantB = {1'b0, normB} >> shift;
      expRes = expA;
    end else begin
      shift = expB - expA;
      mantA = {1'b0, normA} >> shift;
      mantB = {1'b0, normB};
      expRes = expB;
    end

    // Add or subtract mantissas
    if(signA == signB) begin
      mantSum = mantA + mantB;
      signRes = signA;
    end else begin
      if(mantA >= mantB) begin
        mantSum = mantA - mantB;
        signRes = signA;
      end else begin
        mantSum = mantB - mantA;
        signRes = signB;
      end
    end

    // Normalize
    if(mantSum[24]) begin
      mantRes = mantSum >> 1;
      expRes = expRes + 1;
    end else begin
      leadingZeros = countLeadingZeros(mantSum);
      mantRes = mantSum << leadingZeros;
      expRes = (expRes > leadingZeros) ? expRes - leadingZeros : 0;
    end

    result = (mantSum == 0) ? 32'b0 : {signRes, expRes, mantRes[22:0]};
  end
endmodule



module FPU_Sub (
    input  [31:0] A,    // f1
    input  [31:0] B,    // f2
    output [31:0] result
);
  // Simply flip the sign of B and use FPU_Add.
  wire [31:0] B_neg;
  assign B_neg = {~B[31], B[30:0]};  // Invert sign bit
  
  FPU_Add add_inst (
    .A(A),
    .B(B_neg),
    .result(result)
  );
endmodule

module FPU_Compare (
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0]  COMP_TYPE, // 0: CEQ, 1: CLE, 2: CLT, 3: CGE, 4: CGT
    output reg    cc       // condition-code: 1 if condition satisfied
);

  // Extract fields for A and B.
  reg        signA, signB;
  reg [7:0]  expA, expB;
  reg [22:0] fracA, fracB;
  reg        isZeroA, isZeroB;
  reg        isNaNA, isNaNB;
  
  // We'll compute a comparison result: cmp = -1 if A<B, 0 if equal, 1 if A>B,
  // or a special marker for NaN.
  integer cmp;  

  always @(*) begin
    // Extract sign, exponent, and fraction.
    signA = A[31];
    expA  = A[30:23];
    fracA = A[22:0];
    
    signB = B[31];
    expB  = B[30:23];
    fracB = B[22:0];
    
    // Determine if A or B is zero (treat +0 and -0 as zero)
    isZeroA = (expA == 8'd0) && (fracA == 23'd0);
    isZeroB = (expB == 8'd0) && (fracB == 23'd0);
    
    // Determine if A or B is NaN: exponent all ones and nonzero fraction.
    isNaNA = (expA == 8'hFF) && (fracA != 0);
    isNaNB = (expB == 8'hFF) && (fracB != 0);
    
    // If either is NaN, we cannot order them reliably.
    if (isNaNA || isNaNB) begin
      cmp = 2; // 2 will indicate a NaN case.
    end
    else if (isZeroA && isZeroB) begin
      cmp = 0; // Treat +0 and -0 as equal.
    end
    else if (signA != signB) begin
      // When the signs differ, negative is less than positive.
      cmp = (signA) ? -1 : 1;
    end
    else begin
      // Same sign: now compare exponents first.
      if (expA > expB)
        cmp = (signA == 0) ? 1 : -1;  // For positives, higher exponent means larger;
                                      // for negatives, higher exponent means more negative.
      else if (expA < expB)
        cmp = (signA == 0) ? -1 : 1;
      else begin
        // Exponents are equal, so compare fractions.
        if (fracA > fracB)
          cmp = (signA == 0) ? 1 : -1;
        else if (fracA < fracB)
          cmp = (signA == 0) ? -1 : 1;
        else
          cmp = 0;
      end
    end
    
    // Now set 'cc' based on COMP_TYPE and our computed cmp:
    // For NaN cases, we simply set cc = 0 (i.e. condition not satisfied).
    if (cmp == 2) begin
      cc = 1'b0;
    end
    else begin
      case (COMP_TYPE)
        3'd0: cc = (cmp == 0);          // Equal: c.eq.s
        3'd1: cc = (cmp <= 0);          // Less-than or equal: c.le.s
        3'd2: cc = (cmp < 0);           // Less than: c.lt.s
        3'd3: cc = (cmp >= 0);          // Greater-than or equal: c.ge.s
        3'd4: cc = (cmp > 0);           // Greater than: c.gt.s
        default: cc = 1'b0;
      endcase
    end
  end

endmodule


module FPU_Mov (
    input  [31:0] A,  // f1
    output [31:0] result  // f0 = f1
);
  assign result = A;
endmodule


module FPU (
    input  [31:0] A,
    input  [31:0] B,
    input  [3:0]  FPUOp,  // 0: add.s, 1: sub.s, 2: c.eq.s, 3: c.le.s, 4: c.lt.s, 5: c.ge.s, 6: c.gt.s, 7: mov.s/mfc1
    output reg [31:0] result,
    output reg cc        // Condition code output (for compare operations)
);
  // Wires for submodule outputs.
  wire [31:0] add_out, sub_out, mov_out;
  
  // Instantiate FPU_Add and FPU_Sub.
  FPU_Add add_inst (
    .A(A),
    .B(B),
    .result(add_out)
  );
  
  FPU_Sub sub_inst (
    .A(A),
    .B(B),
    .result(sub_out)
  );
  
  // Instantiate FPU_Mov.
  FPU_Mov mov_inst (
    .A(A),
    .result(mov_out)
  );
  
  // For comparisons we will instantiate FPU_Compare with appropriate parameters.
  // We use a wire that will carry the comparator result.
  reg [2:0] comp_mode;
  wire compare_cc;
  
  // Instantiate one comparator; its COMP_TYPE is set by comp_mode.
  FPU_Compare cmp_inst_eq (.A(A), .B(B), .COMP_TYPE(comp_mode) ,.cc(compare_cc));
  // Note: In a real design you might instantiate multiple comparators or reconfigure one;
  // here, to illustrate the idea, we use the comparator output (compare_cc) as computed for COMP_TYPE=0.
  // In the case statement below, we override comp_mode by doing simple comparisons on A and B.
  
  always @(*) begin
    case (FPUOp)
      4'b0000: begin // add.s
        result = add_out;
      end
      4'b0001: begin // sub.s
        result = sub_out;
      end
      4'b0010: begin // c.eq.s
        comp_mode = 3'b000; 
        cc = compare_cc;
        result = A;
      end
      4'b0011: begin // c.le.s 
        comp_mode = 3'b001;
        cc = compare_cc; 
        result = A;
      end
      4'b0100: begin // c.lt.s 
        comp_mode = 3'b010; 
        cc = compare_cc; 
        result = A;
      end
      4'b0101: begin // c.ge.s
        comp_mode = 3'b011;
        cc = compare_cc; 
        result = A;
      end
      4'b0110: begin // c.gt.s
        comp_mode = 3'b100;
        cc = compare_cc; 
        result = A;
      end
      4'b0111: begin // mov.s, mfc1
        result = mov_out;
      end
      default: begin
      end
    endcase
  end

endmodule


