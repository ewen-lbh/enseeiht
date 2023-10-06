library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity compteur8 is
    port ( clk : in  std_logic;
           reset : in  std_logic;
           cpt : out  std_logic_vector (2 downto 0));
end compteur8;

architecture behavioral of compteur8 is

begin

process(clk, reset)

  variable cpt_aux : std_logic_vector (2 downto 0);
  
  begin
  
    if (reset = '0') then
	   cpt_aux := (others => '0');
		cpt <= cpt_aux;
    elsif(rising_edge(clk)) then
	   cpt_aux := cpt_aux + 1;
		cpt <= cpt_aux;
	 end if;
	 
end process;

end behavioral;

