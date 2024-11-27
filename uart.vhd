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
	signal intTransmit, intReceive, intTsr_shift, intRsr_shift, baudClkx8, baudClk, rcvrCtrlClkOut, rcvrRead: std_logic;
	signal gnd: std_logic_vector(7 downto 0) := "00000000";
	signal pow: std_logic_vector(7 downto 0) := "11111111";
	signal action: std_logic_vector(3 downto 0);
	signal transState, rcvrState: std_logic_vector(1 downto 0);

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

	rcvrChange: myDff
	port map (
		clk => rcvrCtrlClkOut,
		d => not(reset) and rcvrState(1) and rcvrState(0),
		q => rcvrRead
	);

	RDR: shiftReg8Bit
	port map (
		clk => rcvrCtrlClkOut,
		a_shift => gnd(0),
		sel(0) => ,
		a => intRsr,
		q => intRdr,
	);

	TDR: shiftReg8Bit
	port map (
		clk => baudClk,
		a_shift => gnd(0),
		sel(1) => '0',
		sel(0) => action(0) and intScsr(7),
		a => data,
		q => intTdr,
	);

	RSR: shiftReg8Bit
	port map (	
		clk => baudClkx8,
		a_shift => rxd,
		sel(0) => '0'
		sel(1) => rcvrRead and not(rcvrState(0)),
		a => gnd,
		q => intRsr,
	);

	TSR: shiftReg8Bit
	port map (
		clk => baudClk,
		a_shift => '1',
		sel(0) => '1'
		sel(1) => ,
		a => intTdr,
		q_shift => txd
	);

	SCSR: shiftReg8Bit
	port map (
		clk => baudClk,
		a_shift => gnd(0),
		sel => ,
		a => ,
		q => ,
	);

	SCCR: inoutReg
	port map (
		clk => baudClk,
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
		clk => baudClk,
		reset => gReset,
		call => intTransmit,
		tdre => intScsr(7),
		state => transState
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
		state => rcvrState
	);

	data <= data when addSel(2) = '0' else 
		intDataOut;

end architecture;
