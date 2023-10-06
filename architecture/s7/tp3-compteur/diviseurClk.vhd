library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_unsigned.ALL;

entity diviseurClk is
  -- facteur : ratio entre la fréquence de l'horloge origine à 100 MHz
  --           et celle de l'horloge générée
  --  ex : 100 MHz -> 1Hz : facteur = 100 000 000
  --  ex : 100 MHz -> 1kHz : facteur = 100 000
  generic(facteur : natural);
  port (
    clk, reset : in  std_logic;
    nclk       : out std_logic);
end diviseurClk;

architecture behavorial of diviseurClk is
	
begin
	  	process (clk, reset)
    variable cpt_aux : std_logic_vector(3 downto 0) := (others => '0');
  begin
    if(reset = '0') then
      cpt_aux := (others => '0');
      nclk <= '0';
    elsif(rising_edge(clk)) then
      cpt_aux := cpt_aux + 1;
      if (cpt_aux = 0) then
			nclk <= '0';
		else
			nclk <= '1';
		end if;
    end if;
  end process;
end behavorial;
