library ieee;
use ieee.std_logic_1164.all;

entity receiverControl is
	port (
		clk, rxd, reset: in std_logic;
		clkOut, rdrf, oe, fe, rdrLoad, rsrShift: out std_logic
	);
end entity;

architecture receiverControlArch of receiverControl is
	signal intCounter, intClkDiv: std_logic_vector(7 downto 0);
	signal intD, intQ, intFallCheck, intRegSel: std_logic_vector(1 downto 0);
	signal intNotReset, intNotClk, intDivReset, intClk, intFallDetect, intParityIn, intParityReset, intParity, intFE, intFED, intFEMuxSel: std_logic;
	signal gnd: std_logic_vector(7 downto 0) := "00000000";
	signal pow: std_logic_vector(7 downto 0) := "11111111";

	component mux2x1
		port (
			in0, in1, s: in std_logic;
			q: out std_logic
		);
	end component;

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
		in0 => clk,
		in1 => clk,
		in2 => intClkDiv(2),
		in3 => intClkDiv(1),
		s => intD,
		q => intClk
	);

	fallCheck0: myDff
	port map (
		clk => intClk,
		d => rxd,
		q => intFallCheck(0)
	);

	fallCheck1: myDff
	port map (
		clk => intClk,
		d => intFallCheck(0),
		q => intFallCheck(1)
	);

	counter: shiftReg8Bit
	port map (
		clk => intClk,
		a_shift => gnd(0),
		sel => intRegSel,
		a => pow,
		q => intCounter
	);

	parity: parityCheck
	port map (
		clk => intClk,
		a => intParityIn,
		reset => intParityReset,
		q => intParity
	);

	feMux: mux2x1
	port map (
		in0 => intFE,
		in1 => intParity,
		s => intFEMuxSel
	);

	feDff: myDff
	port map (
		clk => intClk,
		d => intFED,
		q => intFE
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

	intNotClk <= not(intClk);
	intDivReset <= not(reset) and (intQ(1) or not(intQ(0)));
	intRegSel(0) <= pow(0);
	intRegSel(1) <= not(intQ(0));
	intFallDetect <= not(intFallCheck(0)) and intFallCheck(1);
	intParityIn <= (not(intQ(0)) and intQ(1)) and intCounter(0) and rxd;
	intParityReset <= reset or intQ(0);
	intFEMuxSel <= intQ(0) nor intQ(1);
	intD(0) <= intQ(1) nor reset;
	intD(1) <= (intQ(0) and not(reset) and intFallDetect) or (intQ(1) and not(reset) and intCounter(0)) or (not(intQ(0)) and intQ(1) and not(reset));
	rdrLoad <= not(intQ(0)) and intQ(1) and intCounter(0);
	rsrShift <= not(intQ(0)) and intQ(1) and not(intCounter(0));
	rdrf <= not(intQ(0)) and intQ(1) and not(intCounter(0));
	fe <= intFE;
	oe <= not(rxd) and (intQ(0) nor intQ(1));
	clkOut <= intClk;
end architecture;