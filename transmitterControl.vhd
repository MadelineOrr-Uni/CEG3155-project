library ieee;
use ieee.std_logic_1164.all;

entity transmitterControl is
	port (
		clk, reset: in std_logic;
		tdre: out std_logic;
		state: out std_logic_vector(1 downto 0)
	);
end entity;

architecture transmitterControlArch of transmitterControl is
	signal intCounter: std_logic_vector(7 downto 0);
	signal intD, intQ, intFallCheck: std_logic_vector(1 downto 0);
	signal intNotReset, intNotClk: std_logic;
	signal gnd: std_logic := '0';
	signal pow: std_logic_vector(7 downto 0) := "11111111";

	component myDff
		port (
			d, clk: in std_logic;
			q, qNot: out std_logic
		);
	end component;

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
	fallCheck0: myDff
	port map (
		clk => clk,
		d => reset,
		q => intFallCheck(0)
	);

	fallCheck1: myDff
	port map (
		clk => clk,
		d => intFallCheck(0),
		q => intFallCheck(1)
	);

	state0: myDff
	port map (
		clk => clk,
		d => intD(0),
		q => intQ(0)
	);

	state1: myDff
	port map (
		clk => clk,
		d => intD(1),
		q => intQ(1)
	);

	counter: shiftReg8Bit
	port map (
		clk => clk,
		a_shift => gnd,
		a => pow,
		sel(0) => pow(0),
		sel(1) => intQ(1),
		q => intCounter
	);

	intNotReset <= not(reset);
	intNotClk <= not(clk);

	intD(0) <= (intQ(0) and not(intQ(1)) and not(reset)) or ((not(intQ(1)) and not(reset)) and (not(intFallCheck(0)) and intFallCheck(1))) or (intQ(0) and not(reset) and intCounter(0));
	intD(1) <= (intQ(0) and not(intQ(1)) and not(reset)) or (intQ(0) and not(reset) and intCounter(0));
	tdre <= intQ(0) nor intQ(1);
	state <= intQ;
end architecture;