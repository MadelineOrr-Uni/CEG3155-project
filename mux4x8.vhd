library ieee;
use ieee.std_logic_1164.all;

entity mux4x8 is
	port (
		in0, in1, in2, in3: in std_logic_vector(7 downto 0);
		s: in std_logic_vector(1 downto 0);
		q: out std_logic
	);
end entity;

architecture mux4x8Arch of mux4x8 is
begin
	q <= in0 when s = "00" else
		in1 when s = "01" else
		in2 when s = "10" else
		in3;
end architecture;