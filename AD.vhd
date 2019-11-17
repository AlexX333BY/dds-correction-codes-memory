library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AD is
    Generic ( a : integer := 4);
    Port ( I : in  STD_LOGIC_VECTOR (a - 1 downto 0);
           O : out  STD_LOGIC_VECTOR (2 ** a - 1 downto 0));
end AD;

architecture Behavioral of AD is
begin
   Main : process (I)
   begin
      O <= (others => '0');
      O(to_integer(unsigned(I))) <= '1';
   end process;
end Behavioral;
