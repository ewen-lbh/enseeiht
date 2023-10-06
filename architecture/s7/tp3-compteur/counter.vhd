----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:26:13 10/06/2023 
-- Design Name: 
-- Module Name:    counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is port (
	clk : in std_logic;
	reset : in std_logic;
	cpt : out std_logic_vector(3 downto 0);
	carry_out: out std_logic
	);
end counter;

architecture Behavioral of counter is
	
begin
	process (clk, reset)
    variable cpt_aux : std_logic_vector(3 downto 0) := (others => '0');
  begin
    if(reset = '0') then
      cpt_aux := (others => '0');
      cpt <= cpt_aux;
		carry_out <= '0';
    elsif(rising_edge(clk)) then
      cpt_aux := cpt_aux + 1;
      cpt <= cpt_aux;
		if(cpt_aux = 0) then
			carry_out <= '1';
		else
			carry_out <= '0';
		end if;	
    end if;
  end process;
end Behavioral;

-- ceci est le code du process permettant de faire évoluer le signal cpt de 0 à F indéfiniment
-- il figure dans le cours et dans le TD 2 consacré aux compteurs 


