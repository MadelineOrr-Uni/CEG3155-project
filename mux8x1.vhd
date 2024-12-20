library ieee;
use ieee.std_logic_1164.all;

entity mux8x1 is
	port (
		in0, in1, in2, in3, in4, in5, in6, in7: in std_logic;
		s: in std_logic_vector(2 downto 0);
		q: out std_logic
	);
end entity;

architecture mux8x1Arch of mux8x1 is
begin
	q <= in0 when s = "000" else
		in1 when s = "001" else
		in2 when s = "010" else
		in3 when s = "011" else
		in4 when s = "100" else
		in5 when s = "101" else
		in6 when s = "110" else
		in7;
end architecture;