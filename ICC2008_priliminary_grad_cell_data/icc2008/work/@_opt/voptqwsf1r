library verilog;
use verilog.vl_types.all;
entity test is
    generic(
        IMAGE_N_PAT     : integer := 108;
        CMD_N_PAT       : integer := 130;
        OUT_LENGTH      : integer := 2080;
        t_reset         : integer := 200
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IMAGE_N_PAT : constant is 1;
    attribute mti_svvh_generic_type of CMD_N_PAT : constant is 1;
    attribute mti_svvh_generic_type of OUT_LENGTH : constant is 1;
    attribute mti_svvh_generic_type of t_reset : constant is 1;
end test;
