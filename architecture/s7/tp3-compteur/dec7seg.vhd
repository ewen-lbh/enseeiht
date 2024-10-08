library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity dec7seg is
  port (
    v : in std_logic_vector(3 downto 0);
	 dot : in std_logic;
    seg : out std_logic_vector (7 downto 0)
  );
end dec7seg;

architecture synthesis of dec7seg is

  signal s : std_logic_vector (7 downto 0);

begin

--  s <= "00111111" when value =  0 else
--       "00000110" when value =  1 else
--       "01011011" when value =  2 else
--       "01001111" when value =  3 else
--       "01100110" when value =  4 else
--       "01101101" when value =  5 else
--       "01111101" when value =  6 else
--       "00000111" when value =  7 else
--       "01111111" when value =  8 else
--       "01101111" when value =  9 else
--       "01110111" when value = 10 else
--       "01111100" when value = 11 else
--       "00111001" when value = 12 else
--       "01011110" when value = 13 else
--       "01111001" when value = 14 else
--       "01110001";

  s(7) <= dot;
  --s(7) <= '0';

  s(6) <= (v(1) and (v(3) or not v(2) or not v(0))) or 
          (v(3) and v(0)) or
          (not v(1) and (v(3) xor v(2))); 
  
  s(5) <= (v(3) and not v(2)) or
          not(v(1) or v(0)) or
          (not v(1) and (v(3) xor v(2))) or
          (v(3) and v(1)) or 
          (v(2) and not v(0));

  s(4) <= not(v(2) or v(0)) or
          (v(1) and not v(0)) or
          (v(3) and (v(2) or v(1)));

  s(3) <= (v(3) and not v(1)) or
          not(v(3) or v(2) or v(0)) or
          (v(2) and (v(1) xor v(0))) or
          (not v(2) and v(1) and v(0));

  s(2) <= (v(3) xor v(2)) or
          (not v(1) and v(0)) or
          (not(v(1) xor v(0)) and not v(2));

  s(1) <= not(v(3) or v(2)) or
          not(v(2) or v(1)) or
          not(v(2) or v(0)) or 
          (not v(3) and not(v(1) xor v(0))) or
          (v(3) and not v(1) and v(0));

  s(0) <= (not v(3) and v(1)) or 
          (v(3) and not v(0)) or 
          (v(2) and v(1)) or 
          not (v(2) or v(0)) or
          (v(3) and not v(2) and not v(1)) or
          (not v(3) and v(2) and v(0));

  seg <= not s;

end synthesis;
