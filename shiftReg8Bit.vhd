library ieee;
use ieee.std_logic_1164.all;

entity shiftReg8Bit is
	port (
		clk, a_shift: in std_logic;
		sel: in std_logic_vector(1 downto 0);
		a: in std_logic_vector(7 downto 0);
		q: out std_logic_vector(7 downto 0);
		q_shift: out std_logic
	);
end entity;

architecture shiftReg8BitArch of shiftReg8Bit is
	signal intQ: std_logic_vector(7 downto 0);
	
	component shiftReg1Bit
		port (
			clk, a_left, a_i: in std_logic;
			sel: in std_logic_vector(1 downto 0);
			q: out std_logic
		);
	end component;
begin
	mem0: shiftReg1Bit
	port map (
		clk => clk,
		a_i => a(0),
		a_left => intQ(1),
		sel => sel,
		q => intQ(0)
	);

	mem1: shiftReg1Bit
	port map (
		clk => clk,
		a_i => a(1),
		a_left => intQ(2),
		sel => sel,
		q => intQ(1)
	);

	mem2: shiftReg1Bit
	port map (
		clk => clk,
		a_i => a(2),
		a_left => intQ(3),
		sel => sel,
		q => intQ(2)
	);

	mem3: shiftReg1Bit
	port map (
		clk => clk,
		a_i => a(3),
		a_left => intQ(4),
		sel => sel,
		q => intQ(3)
	);

	mem4: shiftReg1Bit
	port map (
		clk => clk,
		a_i => a(4),
		a_left => intQ(5),
		sel => sel,
		q => intQ(4)
	);

	mem5: shiftReg1Bit
	port map (
		clk => clk,
		a_i => a(5),
		a_left => intQ(6),
		sel => sel,
		q => intQ(5)
	);

	mem6: shiftReg1Bit
	port map (
		clk => clk,
		a_i => a(6),
		a_left => intQ(7),
		sel => sel,
		q => intQ(6)
	);

	mem7: shiftReg1Bit
	port map (
		clk => clk,
		a_i => a(7),
		a_left => a_shift,
		sel => sel,
		q => intQ(7)
	);

	q_shift <= intQ(0);
	q <= intQ;
end architecture;