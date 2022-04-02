library verilog;
use verilog.vl_types.all;
entity LCD_CTRL is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        datain          : in     vl_logic_vector(7 downto 0);
        cmd             : in     vl_logic_vector(2 downto 0);
        cmd_valid       : in     vl_logic;
        dataout         : out    vl_logic_vector(7 downto 0);
        output_valid    : out    vl_logic;
        busy            : out    vl_logic
    );
end LCD_CTRL;
