library verilog;
use verilog.vl_types.all;
entity DFFSHQX4 is
    port(
        Q               : out    vl_logic;
        D               : in     vl_logic;
        CK              : in     vl_logic;
        SN              : in     vl_logic
    );
end DFFSHQX4;
