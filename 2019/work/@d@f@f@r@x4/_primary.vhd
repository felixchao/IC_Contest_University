library verilog;
use verilog.vl_types.all;
entity DFFRX4 is
    port(
        Q               : out    vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic;
        CK              : in     vl_logic;
        RN              : in     vl_logic
    );
end DFFRX4;