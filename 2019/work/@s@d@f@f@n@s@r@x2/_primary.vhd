library verilog;
use verilog.vl_types.all;
entity SDFFNSRX2 is
    port(
        Q               : out    vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic;
        SI              : in     vl_logic;
        SE              : in     vl_logic;
        CKN             : in     vl_logic;
        SN              : in     vl_logic;
        RN              : in     vl_logic
    );
end SDFFNSRX2;
