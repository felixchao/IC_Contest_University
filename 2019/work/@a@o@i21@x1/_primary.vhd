library verilog;
use verilog.vl_types.all;
entity AOI21X1 is
    port(
        Y               : out    vl_logic;
        A0              : in     vl_logic;
        A1              : in     vl_logic;
        B0              : in     vl_logic
    );
end AOI21X1;
