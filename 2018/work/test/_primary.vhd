library verilog;
use verilog.vl_types.all;
entity test is
    generic(
        IMAGE_N_PAT     : integer := 64;
        CMD_N_PAT       : integer := 46;
        t_reset         : real    := 2.000000e+001
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IMAGE_N_PAT : constant is 1;
    attribute mti_svvh_generic_type of CMD_N_PAT : constant is 1;
    attribute mti_svvh_generic_type of t_reset : constant is 1;
end test;
