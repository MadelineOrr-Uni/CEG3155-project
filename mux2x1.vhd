library ieee;
use ieee.std_logic_1164.all;

entity mux2x1 is
	port (
		in0, in1, s: in std_logic;
		q: out std_logic
	);
end entity;

architecture mux2x1Arch of mux2x1 is
begin
	q <= in0 when s = '0' else
		in1;
end architecture;