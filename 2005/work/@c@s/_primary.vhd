library verilog;
use verilog.vl_types.all;
entity CS is
    port(
        Y               : out    vl_logic_vector(9 downto 0);
        X               : in     vl_logic_vector(7 downto 0);
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end CS;
