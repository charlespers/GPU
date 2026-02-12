module sm_execute #(
    parameter THREADS = 4,
    parameter REGS = 16,
    parameter DATA_W = 32
)(
    input wire clk,
    input wire [31:0] instruction,
    input wire [THREADS-1:0] active_mask
);
    wire [3:0] opcode;
    wire [$clog2(REGS)-1:0] rd;
    wire [$clog2(REGS)-1:0] rs1;
    wire [$clog2(REGS)-1:0] rs2;
    wire [15:0] imm;
    assign opcode = instruction[31:28];
    assign rd = instruction [27:25];
    assign rs1 = instruction [23:20];
    assign rs2 = instruction [19:16];
    assign imm = instruction [15:0];

    wire [THREADS*DATA_W-1:0] rs1_data;
    wire [THREADS*DATA_W-1:0] rs2_data;
    wire [THREADS*DATA_W-1:0] rd_data;
    wire rf_we;

    regfile #(
        .THREADS(THREADS),
        .REGS(REGS).
        .DATA_W(DATA_W)
    ) rf (
        .clk(clk),
        .we(rf_we),
        .active_mask(active_mask),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd_data(rd_data)
    );

    simd_alu #(
        .THREADS(THREADS),
        .DATA_W(DATA_W)
    ) alu (
        .opcode(opcode),
        .rs1_data(rs1_data).
        .rs2_data(rs2_data),
        .imm(imm),
        .rd_data(rd_data),
        .we(rd_we)
    );

endmodule