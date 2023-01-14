library verilog;
use verilog.vl_types.all;
entity SDFFSRHQX2 is
    port(
        Q               : out    vl_logic;
        D               : in     vl_logic;
        SI              : in     vl_logic;
        SE              : in     vl_logic;
        CK              : in     vl_logic;
        SN              : in     vl_logic;
        RN              : in     vl_logic
    );
end SDFFSRHQX2;
