// Self-checking testbench for the 2-bit comparator.

module tb;

  reg [1:0] t_a;
  reg [1:0] t_b;

  wire t_gt;
  wire t_lt;
  wire t_eq;

  reg exp_gt;
  reg exp_lt;
  reg exp_eq;

  integer a;
  integer b;
  integer errors;
  integer total;

  comp2 U1 (
    .A(t_a),
    .B(t_b),
    .GT(t_gt),
    .LT(t_lt),
    .EQ(t_eq)
  );

  // Waveform dump
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
  end

  initial begin

    errors = 0;
    total = 0;

    for (a = 0; a < 4; a = a + 1) begin
      for (b = 0; b < 4; b = b + 1) begin

        t_a = a;
        t_b = b;

        // Allow combinational logic to settle
        #1;

        // Calculate expected result independently
        if (a > b) begin
          exp_gt = 1;
          exp_lt = 0;
          exp_eq = 0;
        end
        else if (a < b) begin
          exp_gt = 0;
          exp_lt = 1;
          exp_eq = 0;
        end
        else begin
          exp_gt = 0;
          exp_lt = 0;
          exp_eq = 1;
        end

        total = total + 1;

        if ({t_gt, t_lt, t_eq} !==
            {exp_gt, exp_lt, exp_eq}) begin

          $display(
            "FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
            $time,
            t_a,
            t_b,
            t_gt,
            t_lt,
            t_eq,
            exp_gt,
            exp_lt,
            exp_eq
          );

          errors = errors + 1;
        end
        else begin

          $display(
            "PASS: A=%b B=%b  GT=%b LT=%b EQ=%b",
            t_a,
            t_b,
            t_gt,
            t_lt,
            t_eq
          );

        end

      end
    end

    $display("----------------------------------------");
    $display("RESULT: %0d/%0d tests passed",
             total - errors, total);
    $display("ERRORS: %0d", errors);
    $display("----------------------------------------");

    $finish;

  end

endmodule