library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HammingDecoder is
    Port ( I : in  STD_LOGIC_VECTOR (6 downto 0);
           IER : out  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (0 to 15));
end HammingDecoder;

architecture Behavioral of HammingDecoder is
begin
   Main : process (I)
      variable error : STD_LOGIC;
      variable inversionPos : INTEGER;
      variable inputCopy : STD_LOGIC_VECTOR (6 downto 0);
      variable inData, outData : STD_LOGIC_VECTOR (3 downto 0);
      variable inHamming : STD_LOGIC_VECTOR (0 to 2);
   begin
      error := '0';
      inversionPos := 0;
      
      inData := (0 => I(0), 1 => I(1), 2 => I(2), 3 => I(4), others => '0');
      inHamming := (0 => I(6), 1 => I(5), 2 => I(3), others => '0');
      
      if (inData(0) xor inData(2) xor inData(3)) /= inHamming(0) then
         error := '1';
         inversionPos := inversionPos + 1;
      end if;
      
      if (inData(0) xor inData(1) xor inData(3)) /= inHamming(1) then
         error := '1';
         inversionPos := inversionPos + 2;
      end if;
      
      if (inData(0) xor inData(1) xor inData(2)) /= inHamming(2) then
         error := '1';
         inversionPos := inversionPos + 4;
      end if;
      
      IER <= error;
      inputCopy := I;
      if error = '1' then
         inputCopy(I'length - inversionPos) := not inputCopy(I'length - inversionPos);
      end if;
      outData := (0 => inputCopy(0), 1 => inputCopy(1), 2 => inputCopy(2), 3 => inputCopy(4), others => '0');
      
      O <= (others => '0');
      O(to_integer(unsigned(outData))) <= '1';
   end process;
end Behavioral;
