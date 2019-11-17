library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HammingEncoder is
    Port ( I : in  STD_LOGIC_VECTOR (0 to 15);
           IER : out  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (6 downto 0));
end HammingEncoder;

architecture Behavioral of HammingEncoder is

begin
   Main : process (I)
      variable singleBitsCount, singleBitPos : INTEGER;
      variable parity : STD_LOGIC;
      variable coded : STD_LOGIC_VECTOR (3 downto 0);
   begin
      singleBitsCount := 0;
      singleBitPos := 0;
      for b in 0 to I'length - 1 loop
         if I(b) = '1' then
            singleBitsCount := singleBitsCount + 1;
            singleBitPos := b;
         end if;
      end loop;
      if singleBitsCount = 1 then
         coded := std_logic_vector(to_unsigned(singleBitPos, coded'length));
         IER <= '0';
         O <= (coded(0) xor coded(1) xor coded(3))
            & (coded(0) xor coded(2) xor coded(3))
            & coded(3)
            & (coded(1) xor coded(2) xor coded(3))
            & coded(2 downto 0);
      else
         IER <= '1';
         O <= (others => '0');
      end if;
   end process;
end Behavioral;
