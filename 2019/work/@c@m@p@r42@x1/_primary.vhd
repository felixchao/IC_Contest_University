library verilog;
use verilog.vl_types.all;
entity CMPR42X1 is
    port(
        S               : out    vl_logic;
        CO              : out    vl_logic;
        ICO             : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic;
        D               : in     vl_logic;
        ICI             : in     vl_logic
    );
end CMPR42X1;
