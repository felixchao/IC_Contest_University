library verilog;
use verilog.vl_types.all;
entity MX3X4 is
    port(
        Y               : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic;
        S0              : in     vl_logic;
        S1              : in     vl_logic
    );
end MX3X4;
