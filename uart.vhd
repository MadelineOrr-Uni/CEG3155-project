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
	signal intDataOut, intTdr, intRsr, intRdr, intScsr, intSccr: std_logic_vector(7 downto 0);
	signal intTransmit, intReceive, intTsr_shift, intRsr_shift, baudClkx8, baudClk: std_logic;
	signal gnd: std_logic_vector(7 downto 0) := "00000000";
	signal pow: std_logic_vector(7 downto 0) := "11111111";
	signal action: std_logic_vector(3 downto 0);
	component mux4x8
		port (
			in0, in1, in2, in3: in std_logic_vector(7 downto 0);
			s: in std_logic_vector(1 downto 0);
			q: out std_logic_vector(7 downto 0)
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
			q: out std_logic_vector(7 downto 0);
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

	component baudRateGen
		port (		
			clk, reset: in std_logic;
			s: in std_logic_vector(2 downto 0);
			q, qx8: out std_logic
		);
	end component;

begin
	writeMux: mux4x8
	port map (
		in0 => intRdr,
		in1 => data,
		in2 => data,
		in3 => data,
		s => addSel(1 downto 0),
		q => intDataOut
	);

	RDR: shiftReg8Bit
	port map (
		clk => clk,
		a_shift => gnd(0),
		sel => ,
		a => intRsr,
		q => intRdr,
		q_shift 
	);

	TDR: shiftReg8Bit
	port map (
		clk => clk,
		a_shift => gnd(0),
		sel(1) => '0',
		sel(0) => action(0),
		a => data,
		q_shift => intTdr_shift
	);

	RSR: shiftReg8Bit
	port map (	
		clk => clk,
		a_shift => rxd,
		sel => ,
		a => ,
		q => ,
		q_shift 
	);

	TSR: shiftReg8Bit
	port map (
		clk => clk,
		a_shift => '1',
		sel => ,
		a => intTdr,
		q => ,
		q_shift => txd
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
		rw => addSel(2),
		en => addSel(1),
		q => intSccr,
		a => data
	);

	addrDecoder: addrDecoder
	port map (
		ADDR => addSel(1 downto 0),
		RW => addSel(2),
		action => action
	);

	transCtrl: transmitterController
	port map (	
		clk => clk,
		reset => gReset,
		call => intTransmit,
		tdre => intScsr(7),
		state => 
	);

	baudRate: baudRateGen
	port map (
		clk => clk,
		reset => gReset,
		s => intSccr(2 downto 0),
		q => baudClk,
		qx8 => baudClkx8
	);

	rcvrCtrl: receiverController 
	port map (
		clk => baudClkx8,
		reset => gReset,
		call => intReceive,
		rxd => rxd,
		rdrf => intScsr(6),
		oe => intScsr(1),
		fe => intScsr(0),
		state => 
	);

	data <= data when addSel(2) = '0' else 
		intDataOut;

end architecture;
