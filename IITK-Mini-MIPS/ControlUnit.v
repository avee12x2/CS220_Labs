module control(
    input clk,
    input reset,
    input [5:0] opcode,
    input [5:0] funct,
    output reg [4:0] ALUOp,
    output reg ALUSrc,
    output reg MAUen,
    output reg [1:0] MAUOp,
    output reg RegDst,
    output reg RegWrite,
    output reg [1:0] MemToReg,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg [1:0] Jump,
    output reg [3:0] FPUOp,
    output reg FPWrite,
    output reg FPWriteData,
    output reg Shift,
    output reg done
);
    always @(*) begin
        if (reset) begin
            // Reset all control signals to default values
            ALUOp <= 5'b00000;
            ALUSrc <= 1'b0;

            MAUen <= 1'b0;
            MAUOp <= 2'b00;

            RegWrite <= 1'b0;
            RegDst <= 1'b0;
            MemToReg <= 2'b00;
            
            MemRead <= 1'b0;
            MemWrite <= 1'b0;
           
            Branch <= 1'b0;

            Jump <= 2'b00;

            FPUOp <= 4'b0000;

            FPWrite <= 1'b0;
            FPWriteData <= 1'b0;

            Shift <= 1'b0;

            done <= 0;
        end else begin
            case (opcode)
                // R-type instructions
                6'd0: begin
                    case (funct)
                        6'd0: begin //sll
                            ALUOp <= 5'b00110; // ALU operation for sll
                            ALUSrc <= 1'b1;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd1: begin //srl
                            ALUOp <= 5'b00111;
                            ALUSrc <= 1'b1;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd2: begin //sla
                            ALUOp <= 5'b00110;
                            ALUSrc <= 1'b1;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd3: begin //sra
                            ALUOp <= 5'b01000;
                            ALUSrc <= 1'b1;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd8: begin //jr
                            ALUOp <= 5'b00000;
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b0;

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b10; // Jump register instruction

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b0;
                        end
                        6'd28: begin //madd
                            ALUOp <= 5'b00000;
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b1;
                            MAUOp <= 2'b00; // madd operation

                            RegWrite <= 1'b0;

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b0;
                        end
                        6'd29: begin //maddu
                            ALUOp <= 5'b00000;
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b1;
                            MAUOp <= 2'b01; // maddu operation

                            RegWrite <= 1'b0;

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b0;
                        end
                        6'd30: begin //mul
                            ALUOp <= 5'b00000;
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b1;
                            MAUOp <= 2'b10; // mul operation

                             RegWrite <= 1'b0;

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b0;
                        end
                        6'd32: begin //add
                            ALUOp <= 5'b00000; // ALU operation for add
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;   
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b0;
                        end
                        6'd33: begin //addu
                            ALUOp <= 5'b00000; // ALU operation for addu
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd34: begin //sub
                            ALUOp <= 5'b00001; // ALU operation for sub
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd35: begin //subu
                            ALUOp <= 5'b00001; // ALU operation for subu
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd36: begin //and
                            ALUOp <= 5'b00010; // ALU operation for and
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd37: begin //or
                            ALUOp <= 5'b00011; // ALU operation for or
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd38: begin //xor
                            ALUOp <= 5'b00100; // ALU operation for xor
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd39: begin //not
                            ALUOp <= 5'b00101; // ALU operation for not
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                        6'd42: begin //slt
                            ALUOp <= 5'b10001; // ALU operation for slt
                            ALUSrc <= 1'b0;

                            MAUen <= 1'b0;

                            RegWrite <= 1'b1;
                            RegDst <= 1'b1; // Destination register is rd
                            MemToReg <= 2'b00; // Write back to register file

                            MemRead <= 1'b0;
                            MemWrite <= 1'b0;

                            Branch <= 1'b0;

                            Jump <= 2'b00;

                            FPUOp <= 4'b0000;

                            FPWrite <= 1'b0;

                            Shift <= 1'b1; // Shift operation
                        end
                    endcase
                end

                // Floating point instructions
                6'd1: begin
                    ALUOp <= 5'b00000; // ALU operation for floating point instructions
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;

                    Jump <= 2'b00;

                    Shift <= 1'b0;

                    if(funct != 6'd8) begin
                        RegWrite <= 1'b0;
                    end
                    else begin
                        RegWrite <= 1'b1;
                        RegDst <= 1'b1; // Destination register is rd
                        MemToReg <= 2'b10; // Write back to register file
                    end

                    case (funct)
                        6'd0: begin //add.s
                        FPUOp <= 4'b0000; // Floating point add operation

                        FPWrite <= 1'b1;
                        FPWriteData <= 1'b0; // Write FPU result to register
                        end
                        6'd1: begin //sub.s
                        FPUOp <= 4'b0001; // Floating point subtract operation

                        FPWrite <= 1'b1;
                        FPWriteData <= 1'b0; // Write FPU result to register
                        end
                        6'd6: begin //mov.s
                        FPUOp <= 4'b0111; // Floating point move operation
                        
                        FPWrite <= 1'b1;
                        FPWriteData <= 1'b0; // Write FPU result to register
                        end
                        6'd8: begin //mfc1
                        FPUOp <= 4'b0111; // Floating point move from coprocessor operation

                        FPWrite <= 1'b0; // No write back to register
                        end
                        6'd9: begin //mtc1
                        FPUOp <= 4'b0000; // Floating point move to coprocessor operation

                        FPWrite <= 1'b1;
                        FPWriteData <= 1'b1; // Write ALU result to register
                        end
                        6'd24: begin //c.eq.s
                        FPUOp <= 4'b0010; // Floating point compare equal operation

                        FPWrite <= 1'b0;
                        end
                        6'd25: begin //c.le.s
                        FPUOp <= 4'b0011; // Floating point compare less than or equal operation

                        FPWrite <= 1'b0;
                        end
                        6'd26: begin //c.lt.s
                        FPUOp <= 4'b0100; // Floating point compare less than operation
                        
                        FPWrite <= 1'b0;
                        end
                        6'd27: begin //c.ge.s
                        FPUOp <= 4'b0101; // Floating point compare greater than or equal operation

                        FPWrite <= 1'b0;
                        end
                        6'd28: begin //c.gt.s
                        FPUOp <= 4'b0110; // Floating point compare greater than operation

                        FPWrite <= 1'b0;
                        end
                    endcase
                end

                //jump instructions
                6'd2: begin //j
                    ALUOp <= 5'b00000; // ALU operation for j
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b0;
                    
                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;

                    Jump <= 2'b01; // Jump instruction

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd3: begin //jal
                    ALUOp <= 5'b00000; // ALU operation for jal
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b1;
                    RegDst <= 1'b0;
                    MemToReg <= 2'b11;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;

                    Jump <= 2'b01; // Jump and link instruction

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end

                // Immediate instructions
                6'd8: begin //addi
                    ALUOp <= 5'b00000; // ALU operation for addi
                    ALUSrc <= 1'b1;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b1;
                    RegDst <= 1'b0;
                    MemToReg <= 2'b00;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;
                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd9: begin //addiu
                    ALUOp <= 5'b00000; // ALU operation for addiu
                    ALUSrc <= 1'b1;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b1;
                    RegDst <= 1'b0;
                    MemToReg <= 2'b00;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;
                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd10: begin //slti
                    ALUOp <= 5'b10001; // ALU operation for slti
                    ALUSrc <= 1'b1;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b1;
                    RegDst <= 1'b0;
                    MemToReg <= 2'b00;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;
                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd11: begin //seq
                    ALUOp <= 5'b10010; // ALU operation for seq
                    ALUSrc <= 1'b1;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b1;
                    RegDst <= 1'b0;
                    MemToReg <= 2'b00;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;
                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd12: begin //andi
                    ALUOp <= 5'b00010; // ALU operation for andi
                    ALUSrc <= 1'b1;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b1;
                    RegDst <= 1'b0;
                    MemToReg <= 2'b00;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;
                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd13: begin //ori
                    ALUOp <= 5'b00011; // ALU operation for ori
                    ALUSrc <= 1'b1;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b1;
                    RegDst <= 1'b0;
                    MemToReg <= 2'b00;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;
                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd14: begin //xori
                    ALUOp <= 5'b00100; // ALU operation for xori
                    ALUSrc <= 1'b1;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b1;
                    RegDst <= 1'b0;
                    MemToReg <= 2'b00;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;
                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd15: begin //lui
                    ALUOp <= 5'b10011; // ALU operation for lui
                    ALUSrc <= 1'b1;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b1;
                    RegDst <= 1'b0;
                    MemToReg <= 2'b00;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b0;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end

                //Branch instructions
                6'd24: begin //beq
                    ALUOp <= 5'b01001; // ALU operation for beq
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b0;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b1;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd25: begin //bne
                    ALUOp <= 5'b01010; // ALU operation for bne
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b0;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b1;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd26: begin //bgt
                    ALUOp <= 5'b01011; // ALU operation for bgt
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b0;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b1;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd27: begin //bgte
                    ALUOp <= 5'b01100; // ALU operation for bgte
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b0;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b1;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd28: begin //ble
                    ALUOp <= 5'b01101; // ALU operation for ble
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b0;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b1;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd29: begin //bleq
                    ALUOp <= 5'b01110; // ALU operation for bleq
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b0;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b1;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd30: begin //bleu
                    ALUOp <= 5'b01111; // ALU operation for bleu
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b0;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b1;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd31: begin //bgtu
                    ALUOp <= 5'b10000; // ALU operation for bgtu
                    ALUSrc <= 1'b0;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b0;

                    MemRead <= 1'b0;
                    MemWrite <= 1'b0;

                    Branch <= 1'b1;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end

                // Load/Store instructions
                6'd35: begin //lw
                    ALUOp <= 5'b00000; // ALU operation for lw
                    ALUSrc <= 1'b1;

                    MAUen <= 1'b0;
                    
                    RegWrite <= 1'b1;
                    RegDst <= 1'b0;
                    MemToReg <= 2'b01;
                    
                    MemRead <= 1'b1;
                    MemWrite <= 1'b0;
                    
                    Branch <= 1'b0;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd43: begin //sw
                    ALUOp <= 5'b00000; // ALU operation for sw
                    ALUSrc <= 1'b1;

                    MAUen <= 1'b0;

                    RegWrite <= 1'b0;
                    
                    MemRead <= 1'b0;
                    MemWrite <= 1'b1;

                    Branch <= 1'b0;

                    Jump <= 2'b00;

                    FPUOp <= 4'b0000;

                    FPWrite <= 1'b0;

                    Shift <= 1'b0;
                end
                6'd63: begin //Halt
                    done <= 1;
                end
            endcase
         end
      end

endmodule