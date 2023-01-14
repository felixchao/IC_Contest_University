library verilog;
use verilog.vl_types.all;
entity DFFSXL is
    port(
        Q               : out    vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic;
        CK              : in     vl_logic;
        SN              : in     vl_logic
    );
end DFFSXL;
