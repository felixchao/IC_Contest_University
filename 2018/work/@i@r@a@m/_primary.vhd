library verilog;
use verilog.vl_types.all;
entity IRAM is
    port(
        IRAM_valid      : in     vl_logic;
        IRAM_data       : in     vl_logic_vector(7 downto 0);
        IRAM_addr       : in     vl_logic_vector(5 downto 0);
        clk             : in     vl_logic
    );
end IRAM;
