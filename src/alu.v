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
    reg signed [DATA_W-1:0] a; //lanes
    reg signed [DATA_W-1:0] b;

    always @(*) begin
        rd_data = '0;   // off 
        we      = 1'b1; // on
        for (t = 0; t < THREADS; t = t+1) begin
            a = rs1_data[t*DATA_W +: DATA_W];
            b = rs2_data[t*DATA_W +: DATA_W];
            case(opcode)
                4'b0000: rd_data[t*DATA_W +: DATA_W] = a + b;        // ADD
                4'b0001: rd_data[t*DATA_W +: DATA_W] = a * b;        // MUL
                4'b0010: rd_data[t*DATA_W +: DATA_W] = a - b;        // SUB
                4'b0011: rd_data[t*DATA_W +: DATA_W] = a & b;        // AND
                4'b0100: rd_data[t*DATA_W +: DATA_W] = a | b;        // OR
                4'b0101: rd_data[t*DATA_W +: DATA_W] = a ^ b;        // XOR

                4'b0110: rd_data[t*DATA_W +: DATA_W] = {{(DATA_W-16){imm[15]}}, imm}; // MOVI
                4'b0111: rd_data[t*DATA_W +: DATA_W] = a + {{(DATA_W-16){imm[15]}}, imm}; // ADDI

                default: begin
                    rd_data[t*DATA_W +: DATA_W] ='0;
                    we = 1'b0;
                end
            endcase
        end
    end
endmodule
