library verilog;
use verilog.vl_types.all;
entity lbp_mem is
    port(
        lbp_valid       : in     vl_logic;
        lbp_data        : in     vl_logic_vector(7 downto 0);
        lbp_addr        : in     vl_logic_vector(13 downto 0);
        clk             : in     vl_logic
    );
end lbp_mem;
