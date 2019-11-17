LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY HammingCodeTests IS
END HammingCodeTests;
 
ARCHITECTURE behavior OF HammingCodeTests IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT HammingEncoder
    PORT(
         I : IN  std_logic_vector(0 to 15);
         IER : OUT  std_logic;
         O : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    
    COMPONENT HammingDecoder
    PORT(
         I : IN  std_logic_vector(6 downto 0);
         IER : OUT  std_logic;
         O : OUT  std_logic_vector(0 to 15)
        );
    END COMPONENT;
    
    COMPONENT ErrorGeneratorForTesting is
    GENERIC ( N : integer := 7 );
    PORT (
          I : IN  STD_LOGIC_VECTOR (0 to N-1);
          EN : IN  STD_LOGIC;
          MASK : IN  STD_LOGIC_VECTOR (0 to N-1);
          O : OUT  STD_LOGIC_VECTOR (0 to N-1)
         );
    END COMPONENT;

   --Inputs
   signal I : std_logic_vector(0 to 15) := (others => '0');
   signal ENABLE_ERROR : std_logic := '0';
   constant ERROR_MASK : std_logic_vector(0 to 6) := (4 => '1', others => '0');

 	--Outputs
   signal O_e, O_err_gen : std_logic_vector(6 downto 0);
   signal O_d : std_logic_vector(0 to 15);
   signal IER_e, IER_d: std_logic;
 
   constant clock_period : time := 10 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut_encoder: HammingEncoder PORT MAP (
          I => I,
          IER => IER_e,
          O => O_e
        );

   uut_errgen: ErrorGeneratorForTesting PORT MAP (
          I => O_e,
          EN => ENABLE_ERROR,
          MASK => ERROR_MASK,
          O => O_err_gen
        );

   uut_decoder: HammingDecoder PORT MAP (
          I => O_err_gen,
          IER => IER_d,
          O => O_d
        );

   -- Clock process definitions
   clock_process :process
   begin
      for b in 0 to I'length - 1 loop
         I <= (others => '0');
         I(b) <= '1';
         wait for clock_period;
         assert (IER_d = '0') report "Decoder error signal not working" severity warning;
         assert (I = O_d) report "Coding error" severity failure;
      end loop;

      ENABLE_ERROR <= '1';
      wait for clock_period;
      assert (IER_d = '1') report "Decoder error signal not working" severity warning;
      assert (I /= O_d) report "Error corrected" severity failure;
      assert (false) report "Error was not corrected" severity failure;
   end process;
END;
