library verilog;
use verilog.vl_types.all;
entity NOR4BBX4 is
    port(
        Y               : out    vl_logic;
        AN              : in     vl_logic;
        BN              : in     vl_logic;
        C               : in     vl_logic;
        D               : in     vl_logic
    );
end NOR4BBX4;
