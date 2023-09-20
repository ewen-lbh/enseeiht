
-- VHDL Instantiation Created from source file add4.vhd -- 11:44:43 09/20/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT add4
	PORT(
		A : IN std_logic_vector(3 downto 0);
		B : IN std_logic_vector(3 downto 0);
		carry_in : IN std_logic;          
		S : OUT std_logic_vector(3 downto 0);
		carry_out : OUT std_logic
		);
	END COMPONENT;

	Inst_add4: add4 PORT MAP(
		A => ,
		B => ,
		carry_in => ,
		S => ,
		carry_out => 
	);


