library ieee;
use ieee.std_logic_1164.all;

entity mux8_to_1 is
    port ( e0 : in  std_logic_vector (3 downto 0);
           e1 : in  std_logic_vector (3 downto 0);
           e2 : in  std_logic_vector (3 downto 0);
           e3 : in  std_logic_vector (3 downto 0);
           e4 : in  std_logic_vector (3 downto 0);
           e5 : in  std_logic_vector (3 downto 0);
           e6 : in  std_logic_vector (3 downto 0);
           e7 : in  std_logic_vector (3 downto 0);
           sel : in  std_logic_vector (2 downto 0);
           s : out  std_logic_vector (3 downto 0));
end mux8_to_1;

architecture behavioral of mux8_to_1 is

begin

  with sel select
    s <= e0 when "000",
	      e1 when "001",
			e2 when "010",
			e3 when "011",
			e4 when "100",
			e5 when "101",
			e6 when "110",
			e7 when "111",
			"XXXX" when others;

end behavioral;

