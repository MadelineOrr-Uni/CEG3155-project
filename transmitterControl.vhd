library ieee;
use ieee.std_logic_1164.all;

entity transmitterControl is
	port (
		clk, reset, call: in std_logic;
		tdre: out std_logic;
		state: out std_logic_vector(1 downto 0)
	);
end entity;

architecture transmitterControlArch of transmitterControl is
	signal intCounter: std_logic_vector(7 downto 0);
	signal intD, intQ: std_logic_vector(1 downto 0);
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
	state0: myDff
	port map (
		clk => clk,
		d => intD(0),
		q => intQ(0)
	);

	counter: shiftReg8Bit
	port map (
		clk => intNotClk,
		a_shift => gnd,
		a => pow,
		sel => intQ,
		q => intCounter
	);

	intNotReset <= not(reset);
	intNotClk <= not(clk);

	intD(0) <= ((intQ(0) nor intQ(1)) and (intNotReset and call)) or (intQ(0) and intCounter(0) and intNotReset);
	intD(1) <= intQ(0) or reset;
	state <= intQ;
	tdre <= not(intQ(0)) and intQ(1);
end architecture;