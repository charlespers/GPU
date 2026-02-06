module regfile #(
    parameter THREADS = 4,
    parameter REGS = 16,
    parameter DATA_W = 32

)(
    input wire clk,
    input wire we,  // warp executer
    input wire [THREADS-1:0] active_mask, // masking
    input wire [$clog2(REGS)-1:0] rd,
    input wire [$clog2(REGS)-1:0] rs1,
    input wire [$clog2(REGS)-1:0] rs2,
)