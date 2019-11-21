library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LIFO_RAM is
    Generic ( WORD_LENGTH : integer := 8;
              ADDR_LENGTH : integer := 2);
    Port ( CLK : in  STD_LOGIC;
           INIT : in  STD_LOGIC;
           WR : in  STD_LOGIC;
           EN : in  STD_LOGIC;
           DATA : inout  STD_LOGIC_VECTOR (0 to WORD_LENGTH - 1);
           SP : out  STD_LOGIC_VECTOR (ADDR_LENGTH - 1 downto 0)
           );
end LIFO_RAM;

architecture Behavioral of LIFO_RAM is
   subtype T_WORD is STD_LOGIC_VECTOR(0 to WORD_LENGTH - 1);
   type T_RAM_DATA is array (0 to 2 ** ADDR_LENGTH - 1) of T_WORD;
   signal ram_data : T_RAM_DATA;
   constant stack_last_addr : integer := 2 ** ADDR_LENGTH - 1;
   signal stack_pointer : integer range 0 to stack_last_addr;
begin
   SP <= std_logic_vector(to_unsigned(stack_pointer, SP'length));
   
   Write_process : process (CLK, WR, DATA, EN, INIT)
      variable new_stack_pointer : integer;
   begin
      if INIT = '1' then
         stack_pointer <= 0;
         ram_data(0) <= (others => '0');
         DATA <= (others => 'Z');
      elsif rising_edge(CLK) then
         if EN = '1' then
            if WR = '0' then
               DATA <= ram_data(stack_pointer);
               if stack_pointer > 0 then
                  stack_pointer <= stack_pointer - 1;
               end if;
            else
               DATA <= (others => 'Z');
               if stack_pointer < stack_last_addr then
                  new_stack_pointer := stack_pointer + 1;
                  stack_pointer <= new_stack_pointer;
                  ram_data(new_stack_pointer) <= DATA;
               end if;
            end if;
         end if;
      end if;
   end process;
end Behavioral;
