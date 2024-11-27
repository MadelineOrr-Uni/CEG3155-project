library ieee;
use ieee.std_logic_1164.all;

entity shiftReg1Bit is
	port (
		clk, a_left, a_i: in std_logic;
		sel: in std_logic_vector(1 downto 0);
		q: out std_logic
	);
end entity;

architecture shiftReg1BitArch of shiftReg1Bit is
	signal intD, intQ: std_logic;

	component mux4x1
		port (
			in0, in1, in2, in3: in std_logic;
			s: in std_logic_vector(1 downto 0);
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
	mux: mux4x1
	port map (
		in0 => intQ,
		in1 => a_i,
		in2 => a_left,
		in3 => a_left,
		s => sel,
		q => intD
	);

	mem: myDff
	port map (
		clk => clk,
		d => intD,
		q => intQ
	);

	q <= intQ;
end architecture;