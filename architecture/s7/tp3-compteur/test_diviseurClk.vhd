--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:40:50 10/06/2023
-- Design Name:   
-- Module Name:   /home/elebihan/enseeiht/architecture/s7/tp3-compteur/test_diviseurClk.vhd
-- Project Name:  tp3-compteur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: diviseurClk
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_diviseurClk IS
END test_diviseurClk;
 
ARCHITECTURE behavior OF test_diviseurClk IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT diviseurClk
	 generic (facteur: natural);
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         nclk : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal nclk : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant nclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: diviseurClk 
	generic map(50)
	PORT MAP (
          clk => clk,
          reset => reset,
          nclk => nclk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.

			reset <= '0';
        wait for 100 ns; -- wait until global set/reset completes
		  reset <= '1';

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
