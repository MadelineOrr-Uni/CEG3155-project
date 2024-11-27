library ieee;
use ieee.std_logic_1164.all;

entity uart is
	port (
		clk: in std_logic;
		addSel: in std_logic_vector(2 downto 0);
		data: inout std_logic_vector(7 downto 0)
	);
end entity;

architecture uartArch of uart is
	signal dataOut: std_logic_vector(7 downto 0);
	
begin
	data <= data when addSel(2) = '0' else

end architecture;