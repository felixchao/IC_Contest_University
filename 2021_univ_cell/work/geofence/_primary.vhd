library verilog;
use verilog.vl_types.all;
entity geofence is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        X               : in     vl_logic_vector(9 downto 0);
        Y               : in     vl_logic_vector(9 downto 0);
        valid           : out    vl_logic;
        is_inside       : out    vl_logic
    );
end geofence;
