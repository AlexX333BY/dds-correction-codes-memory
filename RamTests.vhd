LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY RamTests IS
END RamTests;
 
ARCHITECTURE behavior OF RamTests IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT RAM
    PORT(
         CLK : IN  std_logic;
         WR : IN  std_logic;
         ADDR : IN  std_logic_vector(1 downto 0);
         DATA : INOUT  std_logic_vector(0 to 7)
        );
    END COMPONENT;
    
   --Inputs
   signal CLK : std_logic := '0';
   signal WR : std_logic := '0';
   signal ADDR : std_logic_vector(1 downto 0) := (others => '0');

	--BiDirs
   signal DATA : std_logic_vector(0 to 7);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RAM PORT MAP (
          CLK => CLK,
          WR => WR,
          ADDR => ADDR,
          DATA => DATA
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
      for address in 0 to 2 ** 2 - 1 loop
         WR <= '0';
         ADDR <= std_logic_vector(to_unsigned(address, ADDR'length));
         DATA <= std_logic_vector(to_unsigned(2 ** address, DATA'length));
         WR <= '1';
         wait for CLK_period;
      end loop;
      
      WR <= '0';
      for address in 0 to 2 ** 2 - 1 loop
         ADDR <= std_logic_vector(to_unsigned(address, ADDR'length));
         wait for CLK_period;
         assert (DATA = std_logic_vector(to_unsigned(2 ** address, DATA'length))) report "Data was not stored properly" severity failure;
      end loop;
      
      assert (false) report "Simulation success" severity failure;
   end process;
END;
