library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ParityDecoder is
    Generic ( L : INTEGER := 4 );
    Port ( I : in  STD_LOGIC_VECTOR (L downto 0);
           IER : out  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (0 to 2 ** L - 1));
end ParityDecoder;

architecture Behavioral of ParityDecoder is
begin
   Main : process (I)
      variable parity : STD_LOGIC;
   begin
      parity := '0';
      for b in 0 to I'length - 2 loop
         parity := parity xor I(b);
      end loop;
      if parity = I(I'length - 1) then
         IER <= '0';
         O <= (others => '0');
         O(to_integer(unsigned(I(L downto 1)))) <= '1';
      else
         IER <= '1';
         O <= (others => '0');
      end if;
   end process;
end Behavioral;
