library verilog;
use verilog.vl_types.all;
entity traffic_light is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        pass            : in     vl_logic;
        R               : out    vl_logic;
        G               : out    vl_logic;
        Y               : out    vl_logic
    );
end traffic_light;
