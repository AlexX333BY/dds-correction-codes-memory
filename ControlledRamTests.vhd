LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY ControlledRamTests IS
END ControlledRamTests;
 
ARCHITECTURE behavior OF ControlledRamTests IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ControlledRAM8
    PORT(
         CLK : IN  std_logic;
         WR : IN  std_logic;
         ADDR : IN  std_logic_vector(1 downto 0);
         DATA : INOUT  std_logic_vector(0 to 7);
         CONTROL_BITS : OUT  std_logic_vector(0 to 3)
        );
    END COMPONENT;

   --Inputs
   signal CLK : std_logic := '0';
   signal WR : std_logic := '0';
   signal ADDR : std_logic_vector(1 downto 0) := (others => '0');

	--BiDirs
   signal DATA : std_logic_vector(0 to 7);

 	--Outputs
   signal CONTROL_BITS : std_logic_vector(0 to 3);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ControlledRAM8 PORT MAP (
          CLK => CLK,
          WR => WR,
          ADDR => ADDR,
          DATA => DATA,
          CONTROL_BITS => CONTROL_BITS
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
      WR <= '0';
      assert (false) report "Writing data to RAM" severity note;
      for i in 0 to 2 ** 2 - 1 loop
         ADDR <= std_logic_vector(to_unsigned(i, ADDR'length));
         DATA <= std_logic_vector(to_unsigned(2 ** i, DATA'length));
         WR <= '1';
         wait for CLK_period;
         WR <= '0';
      end loop;
      
      DATA <= (others => 'Z');
      assert (false) report "Reading data from RAM" severity note;
      for i in 0 to 2 ** 2 - 1 loop
         ADDR <= std_logic_vector(to_unsigned(i, ADDR'length));
         wait for CLK_period;
      end loop;
      
      assert (false) report "Successful simulation" severity failure;
   end process;
END;
