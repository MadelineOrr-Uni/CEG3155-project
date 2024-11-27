library ieee;
use ieee.std_logic_1164.all;

entity baudRateGen is
	port (
		clk, reset: in std_logic;
		s: in std_logic_vector(2 downto 0);
		q, qx8: out std_logic
	);
end entity;

architecture baudRateGenArch of baudRateGen is
	signal gnd: std_logic_vector(7 downto 0) := "00000000";
	signal intDivdClk, intNotReset, intClkx8: std_logic;
	signal intCount, intSlowClk: std_logic_vector(7 downto 0);

	component mux8x1
		port (
			in0, in1, in2, in3, in4, in5, in6, in7: in std_logic;
			s: in std_logic_vector(2 downto 0);
			q: out std_logic
		);
	end component;

	component counter8Bit
		port (
			clk, s: in std_logic;
			a: in std_logic_vector(7 downto 0);
			q: out std_logic_vector(7 downto 0)
		);
	end component;

	component div41
		port (
			clk, reset: in std_logic;
			q: out std_logic
		);
	end component;
begin
	firstDiv: div41
	port map (
		clk => clk,
		reset => reset,
		q => intDivdClk
	);

	secondDiv: counter8Bit
	port map (
		clk => intDivdClk,
		a => gnd,
		s => intNotReset,
		q => intCount
	);

	mux: mux8x1
	port map (
		in0 => intCount(0),
		in1 => intCount(1),
		in2 => intCount(2),
		in3 => intCount(3),
		in4 => intCount(4),
		in5 => intCount(5),
		in6 => intCount(6),
		in7 => intCount(7),
		s => s,
		q => intClkx8
	);

	thirdDiv: counter8Bit
	port map (
		clk => intClkx8,
		a => gnd,
		s => intNotReset,
		q => intSlowClk
	);

	intNotReset <= not(reset);
	qx8 <= intClkx8;
	q <= intSlowClk(3);
end architecture;