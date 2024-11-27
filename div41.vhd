library ieee;
use ieee.std_logic_1164.all;

entity div41 is
	port (
		clk, reset: in std_logic;
		q: out std_logic
	);
end entity;

architecture div41Arch of div41 is
	signal intReset, intCount41: std_logic;
	signal intQ: std_logic_vector(7 downto 0);
	signal gnd: std_logic_vector(7 downto 0) := "00000000";

	component counter8Bit
		port (
			clk, s: in std_logic;
			a: in std_logic_vector(7 downto 0);
			q: out std_logic_vector(7 downto 0)
		);
	end component;
begin
	div: counter8Bit
	port map (
		clk => clk,
		a => gnd,
		s => intReset,
		q => intQ
	);

	intReset <= not(reset) and intCount41;
	intCount41 <= intQ(0) and intQ(3) and intQ(5);
	q <= intCount41;
end architecture;