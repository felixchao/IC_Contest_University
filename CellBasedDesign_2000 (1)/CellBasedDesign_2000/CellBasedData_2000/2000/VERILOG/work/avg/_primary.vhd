library verilog;
use verilog.vl_types.all;
entity avg is
    port(
        din             : in     vl_logic_vector(15 downto 0);
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        ready           : out    vl_logic;
        dout            : out    vl_logic_vector(15 downto 0)
    );
end avg;
