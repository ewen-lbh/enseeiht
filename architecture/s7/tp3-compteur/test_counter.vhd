-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT counter
          PORT(
                  reset : IN std_logic;
                  clk: IN std_logic;       
                  cpt : OUT std_logic_vector(3 downto 0);
						carry_out : OUT std_logic
                  );
          END COMPONENT;

         signal reset : std_logic;
         signal clk:  std_logic;       
			signal cpt : std_logic_vector(3 downto 0);
			signal carry_out :  std_logic; 
			
			constant clk_period :time := 10 ns;

  BEGIN

  -- Component Instantiation
          uut: counter PORT MAP(
                  reset => reset,
						clk => clk,
						cpt => cpt,
						carry_out => carry_out
          );


	clk_process : process
	begin 
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
	end process clk_process;
	

  --  Test Bench Statements
     tb : PROCESS
     BEGIN

			reset <= '0';
        wait for 100 ns; -- wait until global set/reset completes
		  reset <= '1';
		  

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
