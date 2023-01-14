library verilog;
use verilog.vl_types.all;
entity BMXX2 is
    port(
        PP              : out    vl_logic;
        X2              : in     vl_logic;
        A               : in     vl_logic;
        S               : in     vl_logic;
        M1              : in     vl_logic;
        M0              : in     vl_logic
    );
end BMXX2;
