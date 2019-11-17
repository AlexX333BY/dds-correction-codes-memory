LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RepeatedCodeTests IS
END RepeatedCodeTests; 

ARCHITECTURE behavior OF RepeatedCodeTests IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RepeatedCodeEncoder
    PORT(
         I : IN  std_logic_vector(0 to 15);
         IER : OUT  std_logic;
         O : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
    COMPONENT RepeatedCodeDecoder
    PORT ( I : IN  std_logic_vector(7 downto 0);
           IER : OUT  std_logic;
           O : OUT  std_logic_vector(0 to 15)
         );
    END COMPONENT;
    
    COMPONENT ErrorGeneratorForTesting is
    GENERIC ( N : integer := 8 );
    PORT (
          I : IN  STD_LOGIC_VECTOR (0 to 7);
          EN : IN  STD_LOGIC;
          MASK : IN  STD_LOGIC_VECTOR (0 to 7);
          O : OUT  STD_LOGIC_VECTOR (0 to 7)
         );
    END COMPONENT;

   --Inputs
   signal I : std_logic_vector(0 to 15) := (others => '0');
   signal ENABLE_ERROR : std_logic := '0';
   constant ERROR_MASK : std_logic_vector(0 to 7) := (1 => '1', others => '0');

 	--Outputs
   signal IER_e, IER_d : std_logic := '0';
   signal O_e : std_logic_vector(7 downto 0) := (others => '0');
   signal O_d : std_logic_vector(0 to 15) := (others => '0');
   signal O_err_gen : std_logic_vector(0 to 7) := (others => '0');
 
   constant clock_period : time := 10 ns;
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   encoder_uut: RepeatedCodeEncoder PORT MAP (
          I => I,
          IER => IER_e,
          O => O_e
        );
   decoder_uut: RepeatedCodeDecoder PORT MAP (
          I => O_err_gen,
          IER => IER_d,
          O => O_d
        );
   error_generator_uut: ErrorGeneratorForTesting PORT MAP (
          I => O_e,
          EN => ENABLE_ERROR,
          MASK => ERROR_MASK,
          O => O_err_gen
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
      assert (I = O_d) report "Expected error encountered" severity failure;
   end process;
END;
