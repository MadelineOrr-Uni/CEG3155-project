library ieee;
use ieee.std_logic_1164.all;

entity uartFsm is
	port (
            clk: in std_logic;
            irq, stateInfo: in std_logic_vector(1 downto 0);
            data: inout std_logic_vector(7 downto 0);
            addSel, rateSel: out std_logic_vector(2 downto 0)
	);
end entity;

architecture uartFsmArch of uartFsm is 

begin

end architecture;
