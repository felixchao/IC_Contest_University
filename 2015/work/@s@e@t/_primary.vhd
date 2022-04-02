library verilog;
use verilog.vl_types.all;
entity SET is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        en              : in     vl_logic;
        central         : in     vl_logic_vector(23 downto 0);
        radius          : in     vl_logic_vector(11 downto 0);
        mode            : in     vl_logic_vector(1 downto 0);
        busy            : out    vl_logic;
        valid           : out    vl_logic;
        candidate       : out    vl_logic_vector(7 downto 0)
    );
end SET;
