
-- VHDL Instantiation Created from source file additionneur.vhd -- 11:54:30 09/20/2023
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

	Inst_additionneur: additionneur PORT MAP(
		X => ,
		Y => ,
		Cin => ,
		S => ,
		Cout => 
	);


