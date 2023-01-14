library verilog;
use verilog.vl_types.all;
entity IROM is
    port(
        IROM_rd         : in     vl_logic;
        IROM_data       : out    vl_logic_vector(7 downto 0);
        IROM_addr       : in     vl_logic_vector(5 downto 0);
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end IROM;
