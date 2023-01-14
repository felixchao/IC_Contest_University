library verilog;
use verilog.vl_types.all;
entity LCD_CTRL is
    generic(
        Write           : integer := 0;
        Shift_Up        : integer := 1;
        Shift_Down      : integer := 2;
        Shift_Left      : integer := 3;
        Shift_Right     : integer := 4;
        Max             : integer := 5;
        Min             : integer := 6;
        Average         : integer := 7;
        Counterclockwise: integer := 8;
        Clockwise       : integer := 9;
        Mirror_X        : integer := 10;
        Mirror_Y        : integer := 11;
        Initialize      : integer := 12;
        Command         : integer := 13
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        cmd             : in     vl_logic_vector(3 downto 0);
        cmd_valid       : in     vl_logic;
        IROM_Q          : in     vl_logic_vector(7 downto 0);
        IROM_rd         : out    vl_logic;
        IROM_A          : out    vl_logic_vector(5 downto 0);
        IRAM_valid      : out    vl_logic;
        IRAM_D          : out    vl_logic_vector(7 downto 0);
        IRAM_A          : out    vl_logic_vector(5 downto 0);
        busy            : out    vl_logic;
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Write : constant is 1;
    attribute mti_svvh_generic_type of Shift_Up : constant is 1;
    attribute mti_svvh_generic_type of Shift_Down : constant is 1;
    attribute mti_svvh_generic_type of Shift_Left : constant is 1;
    attribute mti_svvh_generic_type of Shift_Right : constant is 1;
    attribute mti_svvh_generic_type of Max : constant is 1;
    attribute mti_svvh_generic_type of Min : constant is 1;
    attribute mti_svvh_generic_type of Average : constant is 1;
    attribute mti_svvh_generic_type of Counterclockwise : constant is 1;
    attribute mti_svvh_generic_type of Clockwise : constant is 1;
    attribute mti_svvh_generic_type of Mirror_X : constant is 1;
    attribute mti_svvh_generic_type of Mirror_Y : constant is 1;
    attribute mti_svvh_generic_type of Initialize : constant is 1;
    attribute mti_svvh_generic_type of Command : constant is 1;
end LCD_CTRL;
