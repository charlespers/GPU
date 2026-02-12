module sm_core #(
    parameter THREADS = 4,
    parameter REGS = 16,
    parameter DATA_W = 32,
    parameter IMEM_DEPTH = 256
) (
    input wire clk
    input wire reset
);

    reg [$clog2(IMEM_DEPTH)-1:0] pc;
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else
            pc <= pc + 1;
    end

    reg [$clog2(IMEM_DEPTH)-1:0] pc;

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else
            pc <= pc + 1;
    end

    reg [31:0] imem [0:IMEM_DEPTH-1];

    wire [31:0] instruction;

    assign instruction = imem[pc];

    wire [THREADS-1:0] active_mask;
    assign active_mask = {THREADS{1'b1}};

    sm_execute #(
        .THREADS(THREADS),
        .REGS(REGS),
        .DATA_W(DATA_W)
    ) execute_unit (
        .clk(clk),
        .instruction(instruction),
        .active_mask(active_mask)
    );

endmodule