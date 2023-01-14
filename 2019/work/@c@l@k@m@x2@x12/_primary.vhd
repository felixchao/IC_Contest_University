library verilog;
use verilog.vl_types.all;
entity CLKMX2X12 is
    port(
        Y               : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        S0              : in     vl_logic
    );
end CLKMX2X12;
