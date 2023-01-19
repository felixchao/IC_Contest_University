Library IEEE; 
use IEEE.std_Logic_1164.all; 
use IEEE.numeric_std.all; 
ENTITY FAS IS Port( 
clk : in std_logic; 
rst : in std_logic; 
data_valid : in std_logic;
fft_valid : out std_logic;
done : out std_logic;

data : in std_logic_vector(15 downto 0);

fft_d0 : out std_logic_vector(31 downto 0);
fft_d1 : out std_logic_vector(31 downto 0);
fft_d2 : out std_logic_vector(31 downto 0);
fft_d3 : out std_logic_vector(31 downto 0);
fft_d4 : out std_logic_vector(31 downto 0);
fft_d5 : out std_logic_vector(31 downto 0);
fft_d6 : out std_logic_vector(31 downto 0);
fft_d7 : out std_logic_vector(31 downto 0);
fft_d8 : out std_logic_vector(31 downto 0);
fft_d9 : out std_logic_vector(31 downto 0);
fft_d10 : out std_logic_vector(31 downto 0);
fft_d11 : out std_logic_vector(31 downto 0);
fft_d12 : out std_logic_vector(31 downto 0);
fft_d13 : out std_logic_vector(31 downto 0);
fft_d14 : out std_logic_vector(31 downto 0);
fft_d15 : out std_logic_vector(31 downto 0);

freq : out std_logic_vector(3 downto 0);
); 

END FAS;
ARCHITECTURE FAS_arc OF FAS IS 
BEGIN 
END FAS_arc;  
