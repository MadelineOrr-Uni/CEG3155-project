library ieee;
use ieee.std_logic_1164.all;

entity uart is
	port (
		clk, rxd: in std_logic;
		addSel: in std_logic_vector(2 downto 0);
		txd: out std_logic;
		gReset: in std_logic;
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

	component receiverController
		port (		
			clk, rxd, call, reset: in std_logic;
			rdrf, oe, fe: out std_logic;
			state: out std_logic_vector(1 downto 0) 
		);
	end component;

begin

	data <= data when addSel(2) = '0' else
		intDataOut;

	RDR: shiftReg8Bit
	port map (
		clk => clk,
		a_shift => ,
		sel => ,
		a => ,
		q => ,
		q_shift 
	);

	TDR: shiftReg8Bit
	port map (
		clk => clk,
		a_shift => ,
		sel => ,
		a => ,
		q => ,
		q_shift 
	);

	RSR: shicftReg8Bit
	port map (	
		clk => clk,
		a_shift => ,
		sel => ,
		a => ,
		q => ,
		q_shift 
	);

	TSR: shiftReg8Bit
	port map (
		clk => clk,
		a_shift => ,
		sel => ,
		a => ,
		q => ,
		q_shift 
	);

	SCSR: shiftReg8Bit
	port map (
		clk => clk,
		a_shift => ,
		sel => ,
		a => ,
		q => ,
		q_shift 
	);

	SCCR: inoutReg
	port map (
		clk => clk,
		rw => ,
		en => ,
		a => 
	);

	transCtrl: transmitterController
	port map (	
		clk => clk,
		reset => gReset,
		call => ,
		tdre => ,
		state => 
	);

	baud: baudRateGen
	port map (
		clk => clk,
		reset => gReset,
		s => ,
		q => ,
		qx8 => 
	);

	rcvrCtrl: receiverController 
	port map (
		clk => clk,
		reset => gReset,
		call => ,
		rxd => ,
		rdrf => ,
		oe => ,
		state => 
	);
end architecture;
