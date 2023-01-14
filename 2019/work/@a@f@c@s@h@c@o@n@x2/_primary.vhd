library verilog;
use verilog.vl_types.all;
entity AFCSHCONX2 is
    port(
        S               : out    vl_logic;
        CO0N            : out    vl_logic;
        CO1N            : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        CI0             : in     vl_logic;
        CI1             : in     vl_logic;
        CS              : in     vl_logic
    );
end AFCSHCONX2;
