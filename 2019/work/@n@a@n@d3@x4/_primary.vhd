library verilog;
use verilog.vl_types.all;
entity NAND3X4 is
    port(
        Y               : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic
    );
end NAND3X4;
