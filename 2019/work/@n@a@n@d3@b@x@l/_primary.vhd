library verilog;
use verilog.vl_types.all;
entity NAND3BXL is
    port(
        Y               : out    vl_logic;
        AN              : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic
    );
end NAND3BXL;
