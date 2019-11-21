library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HammingEncoder8 is
    Port ( RAM_WR : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           I : in  STD_LOGIC_VECTOR (0 to 7);
           O : out  STD_LOGIC_VECTOR (0 to 3));
end HammingEncoder8;

architecture Behavioral of HammingEncoder8 is
begin
   Main : process (CLK, RAM_WR)
   begin
      if rising_edge(CLK) then
         if RAM_WR = '0' then
            O <= (I(0) xor I(1) xor I(3) xor I(4) xor I(6))
               & (I(0) xor I(2) xor I(3) xor I(5) xor I(6))
               & (I(1) xor I(2) xor I(3) xor I(7))
               & (I(4) xor I(5) xor I(6) xor I(7));
         else
            O <= (others => '0');
         end if;
      end if;
   end process;
end Behavioral;
