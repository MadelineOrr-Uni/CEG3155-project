library ieee;
use ieee.std_logic_1164.all;

entity srLatch is
	port (
  		en, set, reset: in std_logic;
  		q, qNot: out std_logic
	);
end entity;

architecture srLatchArch of srLatch is
	signal intQ, intQNot, intS, intRS: std_logic;
begin
	intS <= set nand en;
	intRS <= reset nand en;
	intQ <= intS nand intQNot;
	intQNot <= intRS nand intQ;

	q <= intQ;
	qNot <= intQNot;
end architecture;