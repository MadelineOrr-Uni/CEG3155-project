library ieee;
use ieee.std_logic_1164.all;

entity fallDetect is
	port (
		clk, a, reset: in std_logic;
		q: out std_logic
	);
end entity;

architecture fallDetectArch of fallDetect is
	signal intFall, intD: std_logic_vector(1 downto 0);

	component myDff
		port (
			d, clk: in std_logic;
			q, qNot: out std_logic
		);
	end component;
begin
	fallDetect0: myDff
	port map (
		clk => clk
		d => intD(0),
		q => intFall(0)
	);

	fallDetect1: myDff
	port map (
		clk => clk,
		d => intD(1),
		q => intFall(1)
	);

	intD(0) <= a and not(reset);
	intD(1) <= intFall(0) and not(reset);
	q <= intFall(1) and not intFall(0);
end architecture;