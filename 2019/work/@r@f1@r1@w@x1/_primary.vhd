library verilog;
use verilog.vl_types.all;
entity RF1R1WX1 is
    port(
        RB              : out    vl_logic;
        WB              : in     vl_logic;
        WW              : in     vl_logic;
        RW              : in     vl_logic;
        RWN             : in     vl_logic
    );
end RF1R1WX1;
