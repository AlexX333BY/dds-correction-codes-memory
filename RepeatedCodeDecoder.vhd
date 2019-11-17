library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity RepeatedCodeDecoder is
    Generic ( L : INTEGER := 4 );
    Port ( I : in  STD_LOGIC_VECTOR (2 * L - 1 downto 0);
           IER : out  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (2 ** L - 1 downto 0));
end RepeatedCodeDecoder;

architecture Behavioral of RepeatedCodeDecoder is
begin
   Main : process (I)
      begin
      if I(2 * L - 1 downto L) = I(L - 1 downto 0) then
         IER <= '0';
         O <= (others => '0');
         O(to_integer(unsigned(I))) <= '1';
      else
         IER <= '1';
         O <= (others => '0');
      end if;
   end process;
end Behavioral;
