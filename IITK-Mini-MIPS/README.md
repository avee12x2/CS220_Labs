
# 🧠 IITK-Mini-MIPS Processor (CS220 Mini Project)

This project implements a simplified MIPS-like processor named **IITK-Mini-MIPS** as part of **CS220 - Computer Organisation** at IIT Kanpur. The processor supports a custom instruction set and is capable of executing MIPS-style programs in a single-cycle datapath design. The entire processor is implemented in **Verilog**.

---

## 📜 Problem Statement

Design and simulate a 32-bit custom processor that:
- Has separate **instruction** and **data memory**
- Supports **R-, I-, and J-type** instructions
- Contains **32 general-purpose** and **32 floating-point** registers
- Executes each instruction in **a single cycle**
- Completes a full **bucket sort program** using the designed ISA

---

## 🛠️ Key Features

- 🔁 **Single-cycle instruction execution**
- 📐 Fully documented **R-, I-, and J-type instruction formats**
- 🧮 Implementation of a custom **Arithmetic Logic Unit (ALU)**
- 🔍 Instruction decoding and **control FSM**
- 🧾 Support for **floating point operations**
- 💾 Custom-designed **instruction and data memory**
- 📋 Testbenches for **verification and simulation**
- 🎯 Working implementation of **Bucket Sort**

---

## 🧩 Architecture Overview

- **Registers**:  
  - 32 General-Purpose Registers (as in MIPS)
  - 32 Floating-Point Registers (with register 31 used for `cc`)
  - Special Registers: `PC`, `hi`, `lo`

- **Memory**:
  - Instruction Memory: 512 words (2KB)
  - Data Memory: 512 words (2KB)

- **Instruction Categories**:
  - **Arithmetic**: `add`, `sub`, `mul`, `madd`, etc.
  - **Logical**: `and`, `or`, `xor`, `not`, shifts
  - **Data Transfer**: `lw`, `sw`, `lui`
  - **Branching**: `beq`, `bgt`, `ble`, `jal`, `jr`, `j`
  - **Comparison**: `slt`, `slti`, `seq`
  - **Floating Point**: `add.s`, `sub.s`, `mov.s`, `mfc1`, `mtc1`, `c.eq.s`, etc.

---

## 🧪 Components Implemented

- [x] Register File
- [x] Instruction Memory
- [x] Data Memory
- [x] ALU with Arithmetic, Logic, Shift and Comparison Units
- [x] Floating-Point Module
- [x] Control Unit with FSM
- [x] Instruction Fetch, Decode, Execute, Memory, Writeback stages
- [x] Bucket Sort Program Execution
- [x] Comprehensive Testbenches

---

## 📦 File Structure

```
IITK-Mini-MIPS/
├── alu.v
├── control_unit.v
├── datapath.v
├── instruction_memory.v
├── data_memory.v
├── register_file.v
├── floating_point_unit.v
├── testbench.v
├── bucket_sort.asm
├── bucket_sort_machine_code.txt
├── IITK Mini MIPS Documentation.pdf
├── assignment_8.pdf
└── README.md
```

---

## 📈 Result

- Successfully simulated execution of **Bucket Sort**
- Result stored in **data memory**
- Verified correctness via **testbench validation**

---

## 👨‍💻 Authors

- **Aarav Oswal** – `230012` – [aaravoswal23@iitk.ac.in](mailto:aaravoswal23@iitk.ac.in)

---

## 📚 References

- MIPS32 Architecture Reference Manual
- CS220 Course Notes and Lectures
- Verilog HDL by Samir Palnitkar

---

## 📝 License

This project is part of coursework and intended for academic use only.
