Charles
02/10/26

module simd_alu #(
    parameter THREADS = 4,
    parameter DATA_W = 32
)(
    // i/o
    input wire [3:0] opcode,
    input wire [THREADS*DATA_W-1:0] rs1_data,
    input wire [THREADS*DATA_W-1:0] rs2_data,
    input wire [15:0]               imm,
    output reg [THREADS*DATA_W-1:0] rd_data,
    output reg                      we
);
    integer t;
    reg signed [DATA_W-1:0] a;
    reg signed [DATA_W-1:0] b;