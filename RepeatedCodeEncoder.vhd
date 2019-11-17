library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity RepeatedCodeEncoder is
    Generic ( L : INTEGER := 4 );
    Port ( I : in  STD_LOGIC_VECTOR (0 to 2 ** L - 1);
           IER : out  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (2 * L - 1 downto 0));
end RepeatedCodeEncoder;

architecture Behavioral of RepeatedCodeEncoder is
begin
   Main : process (I)
      variable singleBitsCount, singleBitPos : INTEGER;
      variable coded : STD_LOGIC_VECTOR (L - 1 downto 0);
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
         O <= coded & coded;
      else
         IER <= '1';
         O <= (others => '0');
      end if;
   end process;
end Behavioral;
