`timescale 1ns/1ps

module tb_sm_core;
    parameter THREADS = 4;
    parameter REGS    = 16;
    parameter DATA_W  = 32;
    parameter IMEM_DEPTH = 16;

    reg clk;
    reg reset;

    sm_core #(
        .THREADS(THREADS),
        .REGS(REGS),
        .DATA_W(DATA_W),
        .IMEM_DEPTH(IMEM_DEPTH)
    ) dut (
        .clk(clk),
        .reset(reset)
    );
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        // MOVI r1, 5
        dut.imem[0] = {4'b0110, 4'd1, 4'd0, 4'd0, 16'd5};
        // MOVI r2, 7
        dut.imem[1] = {4'b0110, 4'd2, 4'd0, 4'd0, 16'd7};
        // ADD r3, r1, r2
        dut.imem[2] = {4'b0000, 4'd3, 4'd1, 4'd2, 16'd0};
        // NOP
        dut.imem[3] = 32'b0;
        #20;
        reset = 0;
        // Run for some cycles
        #100;
        $display("Register r3 values per thread:");
        $display("Thread 0: %d", dut.execute_unit.rf.regfile[0][3]);
        $display("Thread 1: %d", dut.execute_unit.rf.regfile[1][3]);
        $display("Thread 2: %d", dut.execute_unit.rf.regfile[2][3]);
        $display("Thread 3: %d", dut.execute_unit.rf.regfile[3][3]);

        $finish;
    end

endmodule