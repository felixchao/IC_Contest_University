library verilog;
use verilog.vl_types.all;
entity SRAM is
    generic(
        BYTES_SIZE      : integer := 8;
        BYTES_CNT       : integer := 4;
        WORD_SIZE       : vl_notype;
        WORD_ADDR_BITS  : integer := 14;
        WORD_CNT        : vl_notype
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        addr            : in     vl_logic_vector;
        read            : in     vl_logic;
        write           : in     vl_logic_vector(3 downto 0);
        DI              : in     vl_logic_vector;
        DO              : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BYTES_SIZE : constant is 1;
    attribute mti_svvh_generic_type of BYTES_CNT : constant is 1;
    attribute mti_svvh_generic_type of WORD_SIZE : constant is 3;
    attribute mti_svvh_generic_type of WORD_ADDR_BITS : constant is 1;
    attribute mti_svvh_generic_type of WORD_CNT : constant is 3;
end SRAM;
