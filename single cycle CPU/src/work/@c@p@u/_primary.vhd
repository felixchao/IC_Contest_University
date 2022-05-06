library verilog;
use verilog.vl_types.all;
entity CPU is
    generic(
        Idle_state      : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        Instruction_Fetch_state: vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        Instruction_Decode_state: vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        Execute_state   : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        Memory_Access_state: vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        Write_Back_state: vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        Finish_state    : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_out        : in     vl_logic_vector(31 downto 0);
        instr_out       : in     vl_logic_vector(31 downto 0);
        instr_read      : out    vl_logic;
        data_read       : out    vl_logic;
        instr_addr      : out    vl_logic_vector(31 downto 0);
        data_addr       : out    vl_logic_vector(31 downto 0);
        data_write      : out    vl_logic_vector(3 downto 0);
        data_in         : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Idle_state : constant is 1;
    attribute mti_svvh_generic_type of Instruction_Fetch_state : constant is 1;
    attribute mti_svvh_generic_type of Instruction_Decode_state : constant is 1;
    attribute mti_svvh_generic_type of Execute_state : constant is 1;
    attribute mti_svvh_generic_type of Memory_Access_state : constant is 1;
    attribute mti_svvh_generic_type of Write_Back_state : constant is 1;
    attribute mti_svvh_generic_type of Finish_state : constant is 1;
end CPU;
