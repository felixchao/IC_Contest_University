library verilog;
use verilog.vl_types.all;
entity ACHCINX4 is
    port(
        CO              : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        CIN             : in     vl_logic
    );
end ACHCINX4;
