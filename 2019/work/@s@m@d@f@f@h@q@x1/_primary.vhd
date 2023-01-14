library verilog;
use verilog.vl_types.all;
entity SMDFFHQX1 is
    port(
        Q               : out    vl_logic;
        D0              : in     vl_logic;
        D1              : in     vl_logic;
        S0              : in     vl_logic;
        SI              : in     vl_logic;
        SE              : in     vl_logic;
        CK              : in     vl_logic
    );
end SMDFFHQX1;
