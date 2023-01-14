library verilog;
use verilog.vl_types.all;
entity DFFSHQX2 is
    port(
        Q               : out    vl_logic;
        D               : in     vl_logic;
        CK              : in     vl_logic;
        SN              : in     vl_logic
    );
end DFFSHQX2;
