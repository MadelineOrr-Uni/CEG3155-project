library ieee;
use ieee.std_logic_1164.all;

entity addrDecoder is 
    port (
        ADDR: in std_logic_vector(1 downto 0);
        RW: in std_logic;
        action: out std_logic_vector(3 downto 0)
    );
end entity;

architecture struct of addrDecoder is 
begin 
    action(0) <= (ADDR(0) nor ADDR(1)) and not RW;
    action(1) <= (ADDR(0) nor ADDR(1)) and RW;
    action(2) <= ADDR(0) and not ADDR(1) and not RW;
    action(3) <= ADDR(0) and not ADDR(1) and RW;
end struct;