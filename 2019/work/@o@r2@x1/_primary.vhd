library verilog;
use verilog.vl_types.all;
entity OR2X1 is
    port(
        Y               : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic
    );
end OR2X1;
