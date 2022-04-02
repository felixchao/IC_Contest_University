library verilog;
use verilog.vl_types.all;
entity LBP is
    generic(
        Request         : integer := 0;
        \Process\       : integer := 1;
        Store           : integer := 2;
        \Finish\        : integer := 3
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        gray_addr       : out    vl_logic_vector(13 downto 0);
        gray_req        : out    vl_logic;
        gray_ready      : in     vl_logic;
        gray_data       : in     vl_logic_vector(7 downto 0);
        lbp_addr        : out    vl_logic_vector(13 downto 0);
        lbp_valid       : out    vl_logic;
        lbp_data        : out    vl_logic_vector(7 downto 0);
        finish          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Request : constant is 1;
    attribute mti_svvh_generic_type of \Process\ : constant is 1;
    attribute mti_svvh_generic_type of Store : constant is 1;
    attribute mti_svvh_generic_type of \Finish\ : constant is 1;
end LBP;
