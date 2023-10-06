library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Nexys4 is
  port (
    -- les 16 switchs
    swt : in std_logic_vector (15 downto 0);
    -- les 5 boutons noirs
    btnC, btnU, btnL, btnR, btnD : in std_logic;
    -- horloge
    mclk : in std_logic;
    -- les 16 leds
    led : out std_logic_vector (15 downto 0);
    -- les anodes pour sélectionner les afficheurs 7 segments à utiliser
    an : out std_logic_vector (7 downto 0);
    -- valeur affichée sur les 7 segments (point décimal compris, segment 7)
    ssg : out std_logic_vector (7 downto 0)
  );
end Nexys4;

architecture synthesis of Nexys4 is

  -- rappel du (des) composant(s)
component add4 
	PORT (
		A : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		carry_in : IN STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		carry_out : OUT STD_LOGIC
	);
END component;

	COMPONENT dec7seg
	PORT(
		v : IN std_logic_vector(3 downto 0);   
		dot : IN std_logic;		
		seg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	signal result : std_logic_vector(3 downto 0);
	signal carry_out : std_logic;

begin

  -- valeurs des sorties (à modifier)
  
  -- aucun afficheur sélectionné
  an(7 downto 0) <= "11111110";
  led(15 downto 0) <= (others => '0');

  -- connexion du (des) composant(s) avec les ports de la carte
  
  Inst_dec7seg: dec7seg port map(
		v => result(3 downto 0),
		dot => carry_out,
		seg => ssg(7 downto 0)
  );
  
  Inst_add: add4 PORT MAP(
		A => swt(3 downto 0),
		B => swt(7 downto 4),
		carry_in => swt(8),
		S => result(3 downto 0),
		carry_out => carry_out
	);
  
    
end synthesis;
