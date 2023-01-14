library verilog;
use verilog.vl_types.all;
entity ACCSHCONX4 is
    port(
        CO0N            : out    vl_logic;
        CO1N            : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        CI0             : in     vl_logic;
        CI1             : in     vl_logic
    );
end ACCSHCONX4;
