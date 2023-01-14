library verilog;
use verilog.vl_types.all;
entity AOI2BB2XL is
    port(
        Y               : out    vl_logic;
        A0N             : in     vl_logic;
        A1N             : in     vl_logic;
        B0              : in     vl_logic;
        B1              : in     vl_logic
    );
end AOI2BB2XL;
