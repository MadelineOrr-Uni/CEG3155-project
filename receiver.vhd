library ieee;
use ieee.std_logic_1164.all;

entity receiver is
	port (
		clk, rxd, reset: in std_logic;
		rdrf, oe, fe: out std_logic;
		receiveData: out std_logic_vector(7 downto 0)
	);
end entity;

architecture receiverArch of receiver is
	signal intClk, intRdrLoad, intRsrShift: std_logic;
	signal intRsr: std_logic_vector(7 downto 0);
	signal gnd: std_logic_vector(7 downto 0) := "00000000";
	
	component shiftReg8Bit
		port (
			clk, a_shift: in std_logic;
			sel: in std_logic_vector(1 downto 0);
			a: in std_logic_vector(7 downto 0);
			q: out std_logic_vector(7 downto 0);
			q_shift: out std_logic
		);
	end component;

	component receiverControl
		port (
			clk, rxd, reset: in std_logic;
			clkOut, rdrf, oe, fe, rdrLoad, rsrShift: out std_logic
		);
	end component;
begin
	controller: receiverControl
	port map (
		clk => clk,
		rxd => rxd,
		reset => reset,
		clkOut => intClk,
		oe => oe,
		fe => fe,
		rdrf => rdrf,
		rdrLoad => intRdrLoad,
		rsrShift => intRsrShift
	);

	rsrReg: shiftReg8Bit
	port map (
		clk => intClk,
		sel(0) => gnd(0),
		sel(1) => intRsrShift,
		a_shift => rxd,
		a => gnd,
		q => intRsr
	);

	rdrReg: shiftReg8Bit
	port map (
		clk => intClk,
		sel(0) => intRdrLoad,
		sel(1) => gnd(0),
		a_shift => gnd(0),
		a => intRsr,
		q => receiveData
	);
end architecture;