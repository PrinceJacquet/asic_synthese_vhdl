library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


-- from bcd to segments

entity decodeur is
	port(
		BCD      : in  std_logic_vector(3 downto 0);
		segments : out std_logic_vector(6 downto 0)
	);
end entity;


architecture combinatoire of decodeur is
begin
	-- segments a-b-c-d-e-f-g
	-- minimal reduncy in the code with "with/select" vs "when/else" 

	with BCD select segments <=
		"1111110" when "0000",
		"0110000" when "0001",
		"1101101" when "0010",
		"1111001" when "0011",
		"0110011" when "0100",
		"1011011" when "0101",
		"1011111" when "0110",
		"1110000" when "0111",
		"1111111" when "1000",
		"1110011" when "1001",
		"0000000" when others;


end combinatoire;





--  A B C D   dec  B4 :B3B2B1B0
--------------------------------
--  0 0 0 0     0   0 : 0 0 0 0
--  0 0 0 1     1   0 : 0 0 0 1
--  0 0 1 0     2   0 : 0 0 1 0
--  0 0 1 1     3   0 : 0 0 1 1
--  0 1 0 0     4   0 : 0 1 0 0
--  0 1 0 1     5   0 : 0 1 0 1
--  0 1 1 0     6   0 : 0 1 1 0
--  0 1 1 1     7   0 : 0 1 1 1
--  1 0 0 0     8   0 : 1 0 0 0
--  1 0 0 1     9   0 : 1 0 0 1

--  1 0 1 0     10  1 : 0 0 0 0
--  1 0 1 1     11  1 : 0 0 0 1
--  1 1 0 0     12  1 : 0 0 1 0
--  1 1 0 1     13  1 : 0 0 1 1
--  1 1 1 0     14  1 : 0 1 0 0
--  1 1 1 1     15  1 : 0 1 0 1