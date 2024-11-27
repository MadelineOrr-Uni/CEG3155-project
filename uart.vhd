library ieee;
use ieee.std_logic_1164.all;

entity uart is
	port (
		clk, rxd: in std_logic;
		addSel: in std_logic_vector(2 downto 0);
		txd: out std_logic;
		data: inout std_logic_vector(7 downto 0)
	);
end entity;

architecture uartArch of uart is
	signal intDataOut: std_logic_vector(7 downto 0);

	component mux4x8
		port (
			in0, in1, in2, in3: in std_logic_vector(7 downto 0);
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

	component inoutReg
		port (
			a: inout std_logic_vector(7 downto 0);
			rw, clk, en: in std_logic
		);
	end component;

	component addrDecoder
		port (
			ADDR: in std_logic_vector(1 downto 0);
			RW: in std_logic;
			action: out std_logic_vector(3 downto 0)
		);
	end component;

	component transmitterController
		port (	
			clk, reset, call: in std_logic;
			tdre: out std_logic;
			state: out std_logic_vector(1 downto 0)
		);
	end component;

	component baudRateGen
		port (		
			clk, reset: in std_logic;
			s: in std_logic_vector(2 downto 0);
			q, qx8: out std_logic
		);
	end component;
begin

	data <= data when addSel(2) = '0' else
		intDataOut;

	RDR: shiftReg8Bit
	port map (
			
	);

	TDR: shiftReg8Bit
	port map (
		
	);

	RSR: shiftReg8Bit
	port map (
		
	);

	TSR: shiftReg8Bit
	port map (
		
	);

	SCSR: shiftReg8Bit
	port map (
		
	);

	SCCR: inoutReg
	port map (
		
	);


end architecture;
