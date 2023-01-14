library verilog;
use verilog.vl_types.all;
entity NAND2X2 is
    port(
        Y               : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic
    );
end NAND2X2;
