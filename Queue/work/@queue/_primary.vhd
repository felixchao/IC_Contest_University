library verilog;
use verilog.vl_types.all;
entity Queue is
    generic(
        Idle            : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        Enqueue         : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        Dequeue         : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        Clear           : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        operation       : in     vl_logic_vector(1 downto 0);
        \in\            : in     vl_logic_vector(7 downto 0);
        \out\           : out    vl_logic_vector(7 downto 0);
        empty           : out    vl_logic;
        full            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Idle : constant is 1;
    attribute mti_svvh_generic_type of Enqueue : constant is 1;
    attribute mti_svvh_generic_type of Dequeue : constant is 1;
    attribute mti_svvh_generic_type of Clear : constant is 1;
end Queue;
