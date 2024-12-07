library ieee;
use ieee.std_logic_1164.all;

entity transmitter is
	port (
		clk, reset: in std_logic;
		dataBus: in std_logic_vector(7 downto 0);
		tdre, txd: out std_logic
	);
end entity;

architecture transmitterArch of transmitter is
	signal gnd : std_logic := '0';
	signal pow : std_logic := '1';
	signal intTxd, intLoadTdr : std_logic;
	signal intState : std_logic_vector(1 downto 0);
	signal intTdr : std_logic_vector(7 downto 0);
	
	component mux4x1
		port (
			in0, in1, in2, in3: in std_logic;
			s: in std_logic_vector(1 downto 0);
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

	component transmitterControl
		port (
			clk, reset: in std_logic;
			tdre: out std_logic;
			state: out std_logic_vector(1 downto 0)
		);
	end component;
begin
	mux: mux4x1
	port map (
		in0 => pow,
		in1 => gnd,
		in2 => pow,
		in3 => intTxd,
		s => intState,
		q => txd
	);

	tsr: shiftReg8Bit
	port map (
		clk => clk,
		a_shift => gnd,
		sel(0) => pow,
		sel(1) => intState(1),
		a => intTdr,
		q_shift => intTxd
	);

	tdr: shiftReg8Bit
	port map (
		clk => clk,
		a_shift => gnd,
		sel(0) => intLoadTdr,
		sel(1) => gnd,
		a => databus,
		q => intTdr
	);

	controller: transmitterControl
	port map (
		clk => clk,
		reset => reset,
		tdre => tdre,
		state => intState
	);

	intLoadTdr <= not(intState(0));
end architecture;