library verilog;
use verilog.vl_types.all;
entity RF2R1WX1 is
    port(
        R1B             : out    vl_logic;
        R2B             : out    vl_logic;
        WB              : in     vl_logic;
        WW              : in     vl_logic;
        R1W             : in     vl_logic;
        R2W             : in     vl_logic
    );
end RF2R1WX1;
