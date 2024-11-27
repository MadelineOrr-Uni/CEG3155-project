library ieee;
use ieee.std_logic_1164.all;

entity receiverControl is
	port (
		clk, rxd, call, reset: in std_logic;
		clkOut, rdrf, oe, fe: out std_logic;
		state: out std_logic_vector(1 downto 0) 
	);
end entity;

architecture receiverControlArch of receiverControl is
	signal intCounter, intClkDiv: std_logic_vector(7 downto 0);
	signal intD, intQ, intMuxSel, intFall: std_logic_vector(1 downto 0);
	signal intNotReset, intNotClk, intDivReset, intClk, intFallDetectIn, intFallDetect, intParityIn, intParityReset, intParity: std_logic;
	signal gnd: std_logic_vector(7 downto 0) := "00000000";
	signal pow: std_logic_vector(7 downto 0) := "11111111";

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

	component parityCheck
		port (
			clk, a, reset: in std_logic;
			q: out std_logic
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

	component counter8Bit
		port (
			clk, s: in std_logic;
			a: in std_logic_vector(7 downto 0);
			q: out std_logic_vector(7 downto 0)
		);
	end component;
begin
	clkDiv: counter8Bit
	port map (
		clk => clk,
		s => intDivReset,
		a => gnd,
		q => intClkDiv
	);

	clkMux: mux4x1
	port map (
		in0 => intClkDiv(2),
		in1 => intClkDiv(3),
		in2 => clk,
		in3 => intClkDiv(3),
		s => intMuxSel,
		q => intClk
	);

	fallDetect0: myDff
	port map (
		clk => clk,
		d => intFallDetectIn,
		q => intFall(0)
	);

	fallDetect1: myDff
	port map (
		clk => clk,
		d => intFall(0),
		q => intFall(1)
	);

	parity: parityCheck
	port map (
		clk => clk,
		a => intParityIn,
		reset => intParityReset,
		q => intParity
	);

	state0: myDff
	port map (
		clk => intClk,
		d => intD(0),
		q => intQ(0)
	);

	state1: myDff
	port map (
		clk => intClk,
		d => intD(1),
		q => intQ(1)
	);

	intNotReset <= not(reset);
	intNotClk <= not(intClk);
	intDivReset <= intNotReset and intQ(0);
	intMuxSel(0) <= not(reset) and intQ(0);
	intMuxSel(1) <= reset or intQ(1);
	intFallDetectIn <= rxd and intNotReset;
	intFallDetect <= not(intFall(0)) and intFall(1);
	intParityIn <= intNotReset and intCounter(1) and rxd;
	intParityReset <= reset or (intQ(0) nor intQ(1));
	intD(0) <= ((intQ(0) nor intQ(1)) and (intFallDetect and intNotReset)) or (intQ(0) and not(intQ(1)) and intNotReset) or ((intQ(0) and intQ(1)) and (intCounter(0) and intNotReset));
	intD(1) <= intQ(0) or reset;
	rdrf <= not(intQ(0)) and intQ(1);
	oe <= not(intQ(0)) and intQ(1) and intFallDetect;
	fe <= intParity xnor rxd;
	clkOut <= intClk;
end architecture;