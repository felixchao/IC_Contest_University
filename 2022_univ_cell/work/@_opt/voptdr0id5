library verilog;
use verilog.vl_types.all;
entity JAM is
    generic(
        Pivot           : integer := 0;
        Replace         : integer := 1;
        Convert         : integer := 2;
        Load            : integer := 3;
        Finish          : integer := 5
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        W               : out    vl_logic_vector(2 downto 0);
        J               : out    vl_logic_vector(2 downto 0);
        Cost            : in     vl_logic_vector(6 downto 0);
        MatchCount      : out    vl_logic_vector(3 downto 0);
        MinCost         : out    vl_logic_vector(9 downto 0);
        Valid           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Pivot : constant is 1;
    attribute mti_svvh_generic_type of Replace : constant is 1;
    attribute mti_svvh_generic_type of Convert : constant is 1;
    attribute mti_svvh_generic_type of Load : constant is 1;
    attribute mti_svvh_generic_type of Finish : constant is 1;
end JAM;
