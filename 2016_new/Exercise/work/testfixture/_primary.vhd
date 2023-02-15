library verilog;
use verilog.vl_types.all;
entity testfixture is
    generic(
        N_EXP           : integer := 16384;
        N_PAT           : vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N_EXP : constant is 1;
    attribute mti_svvh_generic_type of N_PAT : constant is 3;
end testfixture;
