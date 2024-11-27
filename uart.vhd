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
	signal intDataOut, intTdr, intScsr, inSccr: std_logic_vector(7 downto 0);

	component mux4x8
		port (
			in0, in1, in2, in3: in std_logic_vector(7 downto 0);
			s: in std_logic_vector(1 downto 0);
			q: out std_logic_vector(7 downto 0)
		);
	end component;

	component addrDecoder is 
	    port (
	        ADDR: in std_logic_vector(1 downto 0);
	        RW: in std_logic;
	        action: out std_logic_vector(3 downto 0)
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

	component transmitterControl
		port (
			clk, reset, call: in std_logic;
			tdre: out std_logic;
			state: out std_logic_vector(1 downto 0)
		);
	end component;

	component receiverControl
		port (
			clk, rxd, call, reset: in std_logic;
			rdrf, oe, fe: out std_logic;
			state: out std_logic_vector(1 downto 0) 
		);
	end component;
begin
	writeMux: mux4x8
	port map (
		in0 => intTdr,
		in1 => intScsr,
		in2 => intSccr,
		in3 => intSccr,
		s => addSel(1 downto 0),
		q => intDataOut
	);



	data <= data when addSel(2) = '0' else
		intDataOut;
end architecture;