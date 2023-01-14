library verilog;
use verilog.vl_types.all;
entity OAI2BB1X4 is
    port(
        Y               : out    vl_logic;
        A0N             : in     vl_logic;
        A1N             : in     vl_logic;
        B0              : in     vl_logic
    );
end OAI2BB1X4;
