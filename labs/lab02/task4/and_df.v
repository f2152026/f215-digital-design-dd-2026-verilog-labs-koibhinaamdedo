// and_df.v
// 2-input AND gate using dataflow modeling.

module and_df (
  input  a,
  input  b,
  output wire y
);

  assign #5 y = a & b;

endmodule