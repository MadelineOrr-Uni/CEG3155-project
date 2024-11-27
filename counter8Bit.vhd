library ieee;
use ieee.std_logic_1164.all;

entity counter8Bit is
	port (
		clk, s: in std_logic;
		a: in std_logic_vector(7 downto 0);
		q: out std_logic_vector(7 downto 0)
	);
end entity;

architecture counter8BitArch of counter8Bit is
	signal pow: std_logic := '1';
	signal intInc: std_logic_vector(6 downto 0);
	signal intQ: std_logic_vector(7 downto 0);

	component counter1Bit
		port (
			clk, a, inc, s: in std_logic;
			q : out std_logic
		);
	end component;
begin
	c0: counter1Bit
	port map (
		clk => clk,
		a => a(0),
		inc => pow,
		s => s,
		q => intQ(0)
	);

	c1: counter1Bit
	port map (
		clk => clk,
		a => a(1),
		inc => intInc(0),
		s => s,
		q => intQ(1)
	);

	c2: counter1Bit
	port map (
		clk => clk,
		a => a(2),
		inc => intInc(1),
		s => s,
		q => intQ(2)
	);

	c3: counter1Bit
	port map (
		clk => clk,
		a => a(3),
		inc => intInc(2),
		s => s,
		q => intQ(3)
	);

	c4: counter1Bit
	port map (
		clk => clk,
		a => a(4),
		inc => intInc(3),
		s => s,
		q => intQ(4)
	);

	c5: counter1Bit
	port map (
		clk => clk,
		a => a(5),
		inc => intInc(4),
		s => s,
		q => intQ(5)
	);

	c6: counter1Bit
	port map (
		clk => clk,
		a => a(6),
		inc => intInc(5),
		s => s,
		q => intQ(6)
	);

	c7: counter1Bit
	port map (
		clk => clk,
		a => a(7),
		inc => intInc(6),
		s => s,
		q => intQ(7)
	);

	intInc(0) <= intQ(0);
	intInc(1) <= intQ(0) and intQ(1);
	intInc(2) <= intQ(0) and intQ(1) and intQ(2);
	intInc(3) <= (intQ(0) and intQ(1)) and (intQ(2) and intQ(3));
	intInc(4) <= (intQ(0) and intQ(1)) and (intQ(2) and intQ(3)) and intQ(4);
	intInc(5) <= (intQ(0) and intQ(1)) and (intQ(2) and intQ(3)) and (intQ(4) and intQ(5));
	intInc(6) <= (intQ(0) and intQ(1)) and (intQ(2) and intQ(3)) and (intQ(4) and intQ(5) and intQ(6));
	q <= intQ;
end architecture;