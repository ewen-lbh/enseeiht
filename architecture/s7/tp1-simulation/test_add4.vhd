LIBRARY ieee;
use ieee.std_logic_1164.all;

entity test_add4 is 

end test_add4;


architecture behavior of test_add4 is 
    component add4
    port (
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        carry_in : in std_logic;
        S : out std_logic_vector(3 downto 0);
        carry_out : out std_logic
    );
    end component;

    signal A: std_logic_vector(3 downto 0) := "0000";
    signal B: std_logic_vector(3 downto 0) := "0000";
    signal carry_in : std_logic := '0';
    signal S : std_logic_vector(3 downto 0);
    signal carry_out : std_logic;
begin

    uut: add4 port map (
        A => A,
        B => B,
        carry_in => carry_in,
        S => S,
        carry_out => carry_out
    );

    A <= "0001", "0011" after 100 ns;
    B <= "0001", "0011" after 100 ns;
    carry_in <= '0', '1' after 100 ns;

end behavior;
