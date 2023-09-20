----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:43:24 09/20/2023 
-- Design Name: 
-- Module Name:    add4 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use 

entity add4 is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           carry_in : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (3 downto 0);
           carry_out : out  STD_LOGIC);
end add4;

architecture Behavioral of add4 is

-- VHDL Instantiation Created from source file add4.vhd -- 11:44:43 09/20/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

		COMPONENT additionneur
	PORT(
		X : IN std_logic;
		Y : IN std_logic;
		Cin : IN std_logic;          
		S : OUT std_logic;
		Cout : OUT std_logic
		);
	END COMPONENT;
	
	signal c1to2, c2to3, c3to4 : std_logic;

	add1st: additionneur PORT MAP(
		X => A(0),
		Y => B(0),
		Cin => carry_in,
		S => S(0),
		Cout => c1to2,
	);

	



begin



end Behavioral;
