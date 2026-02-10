Charles
02/07/2026

module regfile #(
    parameter THREADS = 4,
    parameter REGS = 16,
    parameter DATA_W = 32

)(
    input wire clk,
    input wire we,  // write enable
    input wire [THREADS-1:0] active_mask, // masking
    input wire [$clog2(REGS)-1:0] rd,
    input wire [$clog2(REGS)-1:0] rs1,
    input wire [$clog2(REGS)-1:0] rs2,
    output wire [THREADS*DATA_W-1:0] rs1_data, // bus
    output wire [THREADS*DATA_W-1:0] rs2_data, 
    input wire [THREADS*DATA_W-1:0] rd_data
);
    /store
    reg [DATA_W-1:0] regfile [0:THREADS-1] [0:REGS-1];
    integer t;

    // read
    generate
        genvar i;
        for (i=0l i < THREADS; i = i+1) begin : READ_PORTS
            assign rs1_data[i*DATA_W +: DATA_W] = regfile[i][rs1];
            assign rs2_data[i*DATA_W +: DATA_W] = regfile[i][rs2];
        end
    endgenerate

    // write
    always @(posedge clk) begin
        if (we) begin
            for (t=0; t <THREADS; t = t+1) begin
                if (active_mask[t]) begin
                    regfile[t][rd] <= rd_data[t*DATA_W +: DATA_W];
                end
            end
        end

    end
endmodule
