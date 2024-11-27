library ieee;
use ieee.std_logic_1164.all;

entity counter1Bit is
	port (
		clk, a, inc, s: in std_logic;
		q : out std_logic
	);
end entity;

architecture counter1BitArch of counter1Bit is
	signal intD: std_logic;

	component mux2x1
		port (
			in0, in1, s: in std_logic;
			q: out std_logic
		);
	end component;

	component myDff
		port (
			d, clk: in std_logic;
			q, qNot: out std_logic
		);
	end component;
begin
	mux: mux2x1
	port map (
		in0 => a,
		in1 => inc,
		s => s,
		q => intD
	);

	mem: myDff
	port map (
		d => intD,
		clk => clk,
		q => q
	);
end architecture;