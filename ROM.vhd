library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM is
    Generic ( WORD_LENGTH : integer := 8;
              ADDR_LENGTH : integer := 2);
    Port ( ADDR : in  STD_LOGIC_VECTOR (ADDR_LENGTH - 1 downto 0);
           OE : in  STD_LOGIC;
           DATA : out  STD_LOGIC_VECTOR (0 to WORD_LENGTH - 1));
end ROM;

architecture Behavioral of ROM is
   subtype T_WORD is STD_LOGIC_VECTOR(0 to WORD_LENGTH - 1);
   type T_ROM_DATA is array (0 to 2 ** ADDR_LENGTH - 1) of T_WORD;
   constant rom_data : T_ROM_DATA := ("10010100", "00010000", "11000000", "10001000");
begin
   DATA <= rom_data(CONV_INTEGER(ADDR)) when OE = '1' else (others => 'Z');
end Behavioral;
