LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY LifoRamTests IS
END LifoRamTests;
 
ARCHITECTURE behavior OF LifoRamTests IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT LIFO_RAM
    PORT(
         CLK : IN  std_logic;
         INIT : IN  std_logic;
         WR : IN  std_logic;
         EN : IN  std_logic;
         DATA : INOUT  std_logic_vector(0 to 7);
         SP : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;

   --Inputs
   signal CLK : std_logic := '0';
   signal INIT : std_logic := '0';
   signal WR : std_logic := '0';
   signal EN : std_logic := '0';

	--BiDirs
   signal DATA : std_logic_vector(0 to 7);
   constant ZERO_DATA : std_logic_vector(0 to 7) := (others => '0');
 	--Outputs
   signal SP : std_logic_vector(1 downto 0);
   constant ZERO_STACK_POINTER : std_logic_vector(1 downto 0) := (others => '0');
   constant TOP_STACK_POINTER : std_logic_vector(1 downto 0) := (others => '1');

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: LIFO_RAM PORT MAP (
          CLK => CLK,
          INIT => INIT,
          WR => WR,
          EN => EN,
          DATA => DATA,
          SP => SP
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
      INIT <= '1';
      wait for CLK_period;
      INIT <= '0';
      assert (SP = ZERO_STACK_POINTER) report "Stack pointer was not initialized" severity failure;
      
      EN <= '0';
      WR <= '1';
      for i in 0 to 2 ** 2 - 1 loop
         DATA <= std_logic_vector(to_unsigned(2 ** i, DATA'length));
         EN <= '1';
         wait for CLK_period;
         EN <= '0';
      end loop;
      assert (SP = TOP_STACK_POINTER) report "Stack pointer is not on top" severity failure;
      
      WR <= '0';
      DATA <= (others => 'Z');
      EN <= '1';
      for i in 2 ** 2 - 2 downto 0 loop
         wait for CLK_period;
         assert (CONV_INTEGER(DATA) = 2 ** i) report "Data was not stored properly" severity failure;
      end loop;
      
      wait for CLK_period;
      assert (DATA = ZERO_DATA) report "Data stored on 0 address is not 0" severity failure;
      
      assert (false) report "Simulation success" severity failure;
   end process;
END;
