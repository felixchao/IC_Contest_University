library verilog;
use verilog.vl_types.all;
entity CLKAND2X4 is
    port(
        Y               : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic
    );
end CLKAND2X4;
