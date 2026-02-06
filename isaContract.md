# ISA V1 Specs

Define the instruction set architecture for GPU.

## Execution Model

- SIMT
- Instruction execute at warp granularity
- All threads execute in lock step
- Controleld by mask

### Warp Properties

- Warp size of 4
- Each warp
  - PC
  - Active mask
  - Warp state

## Instruction Width

- 32 bits
- for now one instruction per warp per cycle

## Registers

- Regs are per thread
- Each thread has 16 general regs
- op codes are in instructions.csv
