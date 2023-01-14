library verilog;
use verilog.vl_types.all;
entity XNOR2X4 is
    port(
        Y               : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic
    );
end XNOR2X4;
