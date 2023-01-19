Library IEEE;
use IEEE.std_Logic_1164.all;
use IEEE.numeric_std.all;
ENTITY triangle IS
port (
                 clk     :   in std_logic;
                  reset  :   in std_logic;
                  nt       :   in std_logic;
                  xi       :   in std_logic_vector(2 downto 0);
                  yi       :   in std_logic_vector(2 downto 0);
                  busy  :   out std_logic;
                  po     :   out std_logic;
                  xo     :   out std_logic_vector(2 downto 0);
                  yo     :   out std_logic_vector(2 downto 0)
                  );

END triangle;
ARCHITECTURE triangle_arc OF triangle IS
BEGIN
END triangle_arc;
