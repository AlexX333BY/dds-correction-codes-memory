library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM is
    Generic ( WORD_LENGTH : integer := 8;
              ADDR_LENGTH : integer := 2);
    Port ( CLK : in  STD_LOGIC;
           WR : in  STD_LOGIC;
           ADDR : in  STD_LOGIC_VECTOR (ADDR_LENGTH - 1 downto 0);
           DATA : inout  STD_LOGIC_VECTOR (0 to WORD_LENGTH - 1));
end RAM;

architecture Behavioral of RAM is
   subtype WORD is STD_LOGIC_VECTOR(0 to WORD_LENGTH - 1);
   type T_RAM_DATA is array (0 to 2 ** ADDR_LENGTH - 1) of WORD;
   signal ram_data : T_RAM_DATA;
begin
   Read_process : process (ram_data, WR, ADDR)
   begin
      if WR = '0' then
         DATA <= ram_data(CONV_INTEGER(ADDR));
      else
         DATA <= (others => 'Z');
      end if;
   end process;

   Write_process : process (CLK, WR, ADDR, DATA)
   begin
      if rising_edge(CLK) then
         if WR = '1' then
            ram_data(CONV_INTEGER(ADDR)) <= DATA;
         end if;
      end if;
   end process;
end Behavioral;
