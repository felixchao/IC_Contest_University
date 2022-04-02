library verilog;
use verilog.vl_types.all;
entity DET is
    port(
        x               : in     vl_logic_vector(20 downto 0);
        y               : in     vl_logic_vector(20 downto 0);
        x1              : in     vl_logic_vector(20 downto 0);
        y1              : in     vl_logic_vector(20 downto 0);
        r               : out    vl_logic_vector(20 downto 0)
    );
end DET;
