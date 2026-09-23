// tb.v
// Self-checking testbench for the 4-bit ALU.

module tb;

  reg  [3:0] t_a;
  reg  [3:0] t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg [3:0] expected;

  integer a_val;
  integer b_val;
  integer op_val;

  integer errors;
  integer total;

  alu U1 (
    .a(t_a),
    .b(t_b),
    .op(t_op),
    .result(t_result)
  );

  // Optional waveform dump
  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, tb);
  end

  initial begin

    errors = 0;
    total = 0;

    // ------------------------------------------------
    // First explicitly test switching op while
    // keeping a and b fixed.
    // ------------------------------------------------

    t_a = 4'd7;
    t_b = 4'd3;

    // Addition: 7 + 3 = 10
    t_op = 1'b0;
    #1;

    expected = 4'd10;

    total = total + 1;

    if (t_result !== expected) begin
      $display(
        "FAIL: a=%0d b=%0d op=ADD got=%0d expected=%0d",
        t_a, t_b, t_result, expected
      );
      errors = errors + 1;
    end
    else begin
      $display(
        "PASS: a=%0d b=%0d op=ADD result=%0d",
        t_a, t_b, t_result
      );
    end

    // Subtraction: 7 - 3 = 4
    // a and b have NOT changed - only op changes.
    t_op = 1'b1;
    #1;

    expected = 4'd4;

    total = total + 1;

    if (t_result !== expected) begin
      $display(
        "FAIL: a=%0d b=%0d op=SUB got=%0d expected=%0d",
        t_a, t_b, t_result, expected
      );
      errors = errors + 1;
    end
    else begin
      $display(
        "PASS: a=%0d b=%0d op=SUB result=%0d",
        t_a, t_b, t_result
      );
    end


    // ------------------------------------------------
    // Test every combination of:
    //
    // a = 0..15
    // b = 0..15
    // op = 0,1
    //
    // Total = 16 * 16 * 2 = 512 tests
    // ------------------------------------------------

    for (a_val = 0; a_val < 16; a_val = a_val + 1) begin

      for (b_val = 0; b_val < 16; b_val = b_val + 1) begin

        // -------------------------
        // Addition
        // -------------------------

        t_a = a_val;
        t_b = b_val;
        t_op = 1'b0;

        #1;

        expected = a_val + b_val;

        total = total + 1;

        if (t_result !== expected) begin

          $display(
            "FAIL: a=%0d b=%0d op=ADD got=%0d expected=%0d",
            t_a,
            t_b,
            t_result,
            expected
          );

          errors = errors + 1;

        end


        // -------------------------
        // Subtraction
        // -------------------------

        t_op = 1'b1;

        #1;

        expected = a_val - b_val;

        total = total + 1;

        if (t_result !== expected) begin

          $display(
            "FAIL: a=%0d b=%0d op=SUB got=%0d expected=%0d",
            t_a,
            t_b,
            t_result,
            expected
          );

          errors = errors + 1;

        end

      end

    end


    // ------------------------------------------------
    // Final summary
    // ------------------------------------------------

    $display("");
    $display("========================================");
    $display("ALU TEST COMPLETE");
    $display("Total tests : %0d", total);
    $display("Passed      : %0d", total - errors);
    $display("Failed      : %0d", errors);
    $display("========================================");

    if (errors == 0)
      $display("ALL TESTS PASSED");
    else
      $display("TESTS FAILED");

    $finish;

  end

endmodule