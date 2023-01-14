library verilog;
use verilog.vl_types.all;
entity AFHCONX4 is
    port(
        S               : out    vl_logic;
        CON             : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        CI              : in     vl_logic
    );
end AFHCONX4;
