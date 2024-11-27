library ieee;
use ieee.std_logic_1164.all;

entity myDff is
	port (
		d, clk: in std_logic;
		q, qNot: out std_logic
	);
end entity;

architecture myDffArch of myDff is
	signal intQ, intQNot, intD, intDNot, intClkNot: std_logic;

	component srLatch
		port (
			en, set, reset: in std_logic;
			q, qNot: out std_logic
		);
	end component;
begin
	masterLatch: srLatch
	port map (
		set => d,
		reset => intDNot,
		en => intClkNot,
		q => intQ,
		qNot => intQNot
	);

	slaveLatch: srLatch
	port map (
		set => intQ,
		reset => intQNot,
		en => clk,
		q => q,
		qNot => qNot
	);

	intDNot <= not(d);
	intClkNot <= not(clk);
end architecture;