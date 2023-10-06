library ieee;
use ieee.std_logic_1164.all;

entity decalage is
    port ( clk : in  std_logic;
           reset : in  std_logic;
           v : out  std_logic_vector (7 downto 0));
end decalage;

architecture behavorial of decalage is

begin

process(clk, reset)

  variable v_aux : std_logic_vector (7 downto 0);
  
  begin
  
    if (reset = '0') then
     v_aux := (0 => '1', others => '0');
	   v <= v_aux;
    elsif(rising_edge(clk)) then
      v_aux := v_aux(6 downto 0) & v_aux(7) ;
      v <= v_aux;
	 end if;
	 
end process;

end behavorial;

