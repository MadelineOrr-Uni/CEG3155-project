library ieee;
use ieee.std_logic_1164.all;

entity inoutReg is
	port (
		a: inout std_logic_vector(7 downto 0);
		q: out std_logic_vector(7 downto 0);
		rw, clk, en: in std_logic
	);
end entity;

architecture inoutRegArch of inoutReg is
	signal gnd: std_logic := '0';
	signal intSel : std_logic;
	signal intQ: std_logic_vector(7 downto 0);

	component shiftReg8Bit
		port (
			clk, a_shift: in std_logic;
			sel: in std_logic_vector(1 downto 0);
			a: in std_logic_vector(7 downto 0);
			q: out std_logic_vector(7 downto 0);
			q_shift: out std_logic
		);
	end component;
begin
	mem: shiftReg8Bit
	port map (
		clk => clk,
		sel(0) => rw,
		sel(1) => gnd,
		a_shift => gnd,
		a => a,
		q => intQ
	);

	intSel <= rw and en;
	a <= intQ when rw = '0' and en = '1' else
		a;
	q <= intQ;
end architecture;