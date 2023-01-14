library verilog;
use verilog.vl_types.all;
entity NOR2BXL is
    port(
        Y               : out    vl_logic;
        AN              : in     vl_logic;
        B               : in     vl_logic
    );
end NOR2BXL;
