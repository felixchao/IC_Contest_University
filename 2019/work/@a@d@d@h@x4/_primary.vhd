library verilog;
use verilog.vl_types.all;
entity ADDHX4 is
    port(
        S               : out    vl_logic;
        CO              : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic
    );
end ADDHX4;
