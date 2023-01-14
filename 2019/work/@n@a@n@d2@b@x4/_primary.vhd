library verilog;
use verilog.vl_types.all;
entity NAND2BX4 is
    port(
        Y               : out    vl_logic;
        AN              : in     vl_logic;
        B               : in     vl_logic
    );
end NAND2BX4;
