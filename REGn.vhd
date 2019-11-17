library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGn is
    Generic ( INITREG : STD_LOGIC_VECTOR := "00000000");
    Port ( INIT : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (INITREG'range);
           EN : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           OE : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (INITREG'range));
end REGn;

architecture Behavioral of REGn is
   signal data, out_data : STD_LOGIC_VECTOR (INITREG'range);
begin
   IN_Process : process (INIT, Din, EN, CLK)
   begin
      if INIT = '1' then
         data <= INITREG;
      elsif rising_edge(CLK) then
         if EN = '1' then
            data <= Din;
         end if;
      end if;
   end process;
   
   Dout <= data when OE = '1' else (others => 'Z');
end Behavioral;
