library verilog;
use verilog.vl_types.all;
entity test is
    generic(
        INPUT_DATA      : string  := "in.dat";
        GOLDEN          : string  := "out_golden.dat";
        N_PAT           : integer := 2000;
        t_reset         : integer := 20
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INPUT_DATA : constant is 1;
    attribute mti_svvh_generic_type of GOLDEN : constant is 1;
    attribute mti_svvh_generic_type of N_PAT : constant is 1;
    attribute mti_svvh_generic_type of t_reset : constant is 1;
end test;
