library verilog;
use verilog.vl_types.all;
entity OAI21X4 is
    port(
        Y               : out    vl_logic;
        A0              : in     vl_logic;
        A1              : in     vl_logic;
        B0              : in     vl_logic
    );
end OAI21X4;
