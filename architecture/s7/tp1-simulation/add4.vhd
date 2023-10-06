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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY add4 IS
	PORT (
		A : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		carry_in : IN STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		carry_out : OUT STD_LOGIC);
END add4;

ARCHITECTURE Behavioral OF add4 IS

	-- VHDL Instantiation Created from source file add4.vhd -- 11:44:43 09/20/2023
	--
	-- Notes: 
	-- 1) This instantiation template has been automatically generated using types
	-- std_logic and std_logic_vector for the ports of the instantiated module
	-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT additionneur
		PORT (
			X : IN STD_LOGIC;
			Y : IN STD_LOGIC;
			Cin : IN STD_LOGIC;
			S : OUT STD_LOGIC;
			Cout : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL c1to2, c2to3, c3to4 : STD_LOGIC;

BEGIN
	add1st : additionneur PORT MAP(
		X => A(0),
		Y => B(0),
		Cin => carry_in,
		S => S(0),
		Cout => c1to2
	);

	add2nd : additionneur PORT MAP(
		X => A(1),
		Y => B(1),
		Cin => c1to2,
		S => S(1),
		Cout => c2to3
	);

	add3rd : additionneur PORT MAP(
		X => A(2),
		Y => B(2),
		Cin => c2to3,
		S => S(2),
		Cout => c3to4
	);

	add4th : additionneur PORT MAP(
		X => A(3),
		Y => B(3),
		Cin => c3to4,
		S => S(3),
		Cout => carry_out
	);
END Behavioral;
