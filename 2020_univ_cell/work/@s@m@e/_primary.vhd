library verilog;
use verilog.vl_types.all;
entity SME is
    generic(
        Load            : integer := 0;
        Check           : integer := 1;
        Case1           : integer := 2;
        Case2           : integer := 3;
        Case3           : integer := 4;
        Case4           : integer := 5;
        \Match\         : integer := 6;
        NotMatch        : integer := 7
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        chardata        : in     vl_logic_vector(7 downto 0);
        isstring        : in     vl_logic;
        ispattern       : in     vl_logic;
        valid           : out    vl_logic;
        match           : out    vl_logic;
        match_index     : out    vl_logic_vector(4 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Load : constant is 1;
    attribute mti_svvh_generic_type of Check : constant is 1;
    attribute mti_svvh_generic_type of Case1 : constant is 1;
    attribute mti_svvh_generic_type of Case2 : constant is 1;
    attribute mti_svvh_generic_type of Case3 : constant is 1;
    attribute mti_svvh_generic_type of Case4 : constant is 1;
    attribute mti_svvh_generic_type of \Match\ : constant is 1;
    attribute mti_svvh_generic_type of NotMatch : constant is 1;
end SME;
