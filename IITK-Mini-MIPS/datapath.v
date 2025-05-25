module datapath(
    input clk,
    input rst,
    input [31:0] instr,
    input [31:0] data,
    input [9:0] instr_addr,
    input [9:0] data_addr,
    input ins_we,
    input data_we,
    output [31:0] MemReadData,
    output done,

    output reg [31:0] ALU_Result_test
    
);

    reg [31:0] PC;
    wire [31:0] Instruction;
    wire [31:0] PCNext;
    wire [31:0] data_write;
    wire mem_we;
    
//    always @(Instruction_wire) begin
//        Instruction <= Instruction_wire;
//    end
    

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 32'b0;
        end else begin
            if (done) begin
                PC <= PC;
            end else begin
                PC <= PCNext;
            end
        end
    end
    
    Instruction_memory_wrapper inst(
        .a(instr_addr),
        .d(instr),
        .dpra(PC[9:0]),
        .clk(clk),
        .we(ins_we),
        .dpo(Instruction)
    );

    wire [4:0] ALUOp;
    wire ALUSrc, MAUen, RegDst, RegWrite, MemRead, MemWrite , Branch, FPWrite, FPWriteData, Shift;
    wire [1:0] MAUOp, MemToReg, Jump;
    wire [3:0] FPUOp;

    control ctrl(
        .clk(clk),
        .reset(rst),
        .opcode(Instruction[31:26]),
        .funct(Instruction[5:0]),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .MAUen(MAUen),
        .MAUOp(MAUOp),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .MemToReg(MemToReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .FPUOp(FPUOp),
        .FPWrite(FPWrite),
        .FPWriteData(FPWriteData),
        .Shift(Shift),
        .done(done)
    );

    wire [5:0] GPRWrite;
    MUX2to1 mux1(
        .a(Instruction[20:16]),
        .b(Instruction[15:11]),
        .sel(RegDst),
        .out(GPRWrite)
    );
    wire [31:0] GPRRead1, GPRRead2, GPRWriteData;
    GPR gpr(
        .clk(clk),
        .reset(rst),
        .read1(Instruction[25:21]),
        .read2(Instruction[20:16]),
        .write(GPRWrite),
        .write_data(GPRWriteData),
        .write_enable(RegWrite),
        .read_data1(GPRRead1),
        .read_data2(GPRRead2)
    );

    wire [15:0] ShiftSelect;
    MUX2to1 mux2(
        .a(Instruction[15:0]),
        .b(Instruction[10:6]),
        .sel(Shift),
        .out(ShiftSelect)
    );
    wire [31:0] ShiftExtended;
    SignExtender16to32 sign_extender(
        .in(ShiftSelect),
        .out(ShiftExtended)
    );

    wire [31:0] ALUIn2;
    MUX2to1 mux3(
        .a(GPRRead2),
        .b(ShiftExtended),
        .sel(ALUSrc),
        .out(ALUIn2)
    );
    
    wire [31:0] ALUResult;
    wire branch;

    ALU alu(
        .A(GPRRead1),
        .B(ALUIn2),
        .ALUOp(ALUOp),
        .result(ALUResult),
        .branch(branch)
    );
    
    reg [31:0] data_read_addr, data_write_addr;

    always@(*)
    begin
        if(done)
            data_read_addr<=data_addr;
        else 
            data_read_addr<=ALUResult[9:0];
    end

    always@(*)
    begin
        if(rst)
            data_write_addr<=data_addr;
        else 
            data_write_addr<=ALUResult[9:0];
    end

    assign data_write=(rst==1)?data:GPRRead2;
    assign mem_we=(rst==1)?data_we:MemWrite;

    memory_wrapper mem(
        .a(data_write_addr),
        .d(data_write),
        .dpra(data_read_addr),
        .clk(clk),
        .we(mem_we),
        .dpo(MemReadData)
    );

    wire [31:0] FPUResult;

    wire [31:0] PCPlus4;
    Adder adder1(
        .a(PC),
        .b(32'd1),
        .sum(PCPlus4)
    );

    MUX4to1 mux4(
        .a(ALUResult),
        .b(MemReadData),
        .c(FPUResult),
        .d(PCPlus4),
        .sel(MemToReg),
        .out(GPRWriteData)
    );

    wire [31:0] FPRRead1, FPRRead2;

    wire [31:0] hi, lo;
    MAU ma_unit(
        .reset(rst),
        .A(GPRRead1),
        .B(GPRRead2),
        .MAUOp(MAUOp),
        .MAUen(MAUen),
        .hi(hi),
        .lo(lo)
    );

    wire [31:0] FPRWriteData;
    MUX2to1 mux5(
        .a(FPUResult),
        .b(ALUResult),
        .sel(FPWriteData),
        .out(FPRWriteData)
    );

    

    FPR fpr(
        .clk(clk),
        .reset(rst),
        .read1(Instruction[25:21]),
        .read2(Instruction[20:16]),
        .write(Instruction[15:11]),
        .write_data(FPRWriteData),
        .write_enable(FPWrite),
        .read_data1(FPRRead1),
        .read_data2(FPRRead2)
    );

    wire cc;

    FPU fpu(
        .A(FPRRead1),
        .B(FPRRead2),
        .FPUOp(FPUOp),
        .cc(cc),
        .result(FPUResult)
    );

    wire [31:0] JumpAddress;
    assign JumpAddress = {PCPlus4[31:26], Instruction[25:0]};

    wire [31:0] BranchAddress;
    Adder adder2(
        .a(PCPlus4),
        .b(ShiftExtended),
        .sum(BranchAddress)
    );

    wire [31:0] BranchTarget;
    MUX2to1 mux6(
        .a(PCPlus4),
        .b(BranchAddress),
        .sel((Branch && branch)),
        .out(BranchTarget)
    );

    
    MUX4to1 mux7(
        .a(BranchTarget),
        .b(JumpAddress),
        .c(ALUResult),
        .d(PCPlus4),
        .sel(Jump),
        .out(PCNext)
    );
    
    always @(ALUResult) begin
        ALU_Result_test <= ALUResult;
    end

endmodule


//Helper  Modules

module Adder(
    input [31:0] a, b,
    output [31:0] sum
);
    assign sum = a + b;
endmodule

module MUX2to1(
    input [31:0] a, b,
    input sel,
    output [31:0] out
);
    assign out = (sel) ? b : a;
endmodule

module MUX4to1(
    input [31:0] a, b, c, d,
    input [1:0] sel,
    output [31:0] out
);
    assign out = (sel == 2'b00) ? a :
                 (sel == 2'b01) ? b :
                 (sel == 2'b10) ? c : d;
endmodule

module SignExtender16to32(
    input [15:0] in,
    output [31:0] out
);
    assign out = { {16{in[15]}}, in };
endmodule