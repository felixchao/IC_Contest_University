Library IEEE; 
use IEEE.std_Logic_1164.all; 
use IEEE.numeric_std.all; 
ENTITY FFT_PE IS Port( 
clk : in std_logic; 
rst : in std_logic; 
ab_valid : in std_logic;
fft_pe_valid : out std_logic;

power : in std_logic_vector(2 downto 0);
a : in std_logic_vector(31 downto 0);
b : in std_logic_vector(31 downto 0);

fft_a : out std_logic_vector(31 downto 0);
fft_b : out std_logic_vector(31 downto 0);

); 

END FFT_PE;
ARCHITECTURE FAS_arc OF FFT_PE IS 
BEGIN 
END FFT_PE_arc; 

