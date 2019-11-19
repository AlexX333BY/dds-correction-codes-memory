LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RegFileTests IS
END RegFileTests;

ARCHITECTURE behavior OF RegFileTests IS 

-- Component Declaration
   COMPONENT REGfile
      Generic ( A : integer := 4;
                INITREG : STD_LOGIC_VECTOR := "0000");
      Port ( INIT : in  STD_LOGIC;
         WDP : in  STD_LOGIC_VECTOR (0 to 3);
         WA : in  STD_LOGIC_VECTOR (3 downto 0);
         RA : in  STD_LOGIC_VECTOR (3 downto 0);
         WE : in  STD_LOGIC;
         RDP : out  STD_LOGIC_VECTOR (0 to 3));
   END COMPONENT;

   SIGNAL INIT, WE :  std_logic := '0';
   SIGNAL RDP, WDP :  std_logic_vector(0 to 3) := (others => '0');
   SIGNAL RA, WA : std_logic_vector(3 downto 0) := (others => '0');
   CONSTANT CLK_period : time := 10 ns; 

BEGIN

   -- Component Instantiation
   uut: REGfile PORT MAP(
      INIT => INIT,
      WDP => WDP,
      WA => WA,
      RA => RA,
      WE => WE,
      RDP => RDP
   );

   DATA_PROC : PROCESS
   BEGIN
      INIT <= '1';
      wait for CLK_period;
      INIT <= '0';
      wait for CLK_period;

      for i in 0 to 2 ** 4 - 1 loop
         WA <= std_logic_vector(to_unsigned(i, WA'length));
         WDP <= std_logic_vector(to_unsigned(2 ** 4 - 1 - i, WDP'length));
         wait for CLK_period;
      end loop;
      
      for i in 0 to 2 ** 4 - 1 loop
         RA <= std_logic_vector(to_unsigned(i, WA'length));
         wait for CLK_period;
         assert (RDP = std_logic_vector(to_unsigned(2 ** 4 - 1 - i, RDP'length))) report "Data was not stored properly" severity failure;
      end loop;
      
      assert (false) report "Simulation success" severity failure;
   END PROCESS;

   --  Test Bench Statements
   CLK_PROC : PROCESS
   BEGIN
      WE <= '0';
      wait for CLK_period/2;
      WE <= '1';
      wait for CLK_period/2;
   END PROCESS;
END;
