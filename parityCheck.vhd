library ieee;
use ieee.std_logic_1164.all;

entity parityCheck is
	port (
		clk, a, reset: in std_logic;
		q: out std_logic
	);
end entity;

architecture parityCheckArch of parityCheck is
	signal intD, intQ: std_logic;

	component myDff
		port (
			d, clk: in std_logic;
			q, qNot: out std_logic
		);
	end component;
begin
	mem: myDff
	port map (
		clk => clk,
		d => intD,
		q => intQ
	);

	intD <= (a xor intQ) and not(reset);
	q <= intQ;
end architecture;