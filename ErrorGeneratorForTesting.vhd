library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ErrorGeneratorForTesting is
    Generic ( N : integer := 1 );
    Port ( I : in  STD_LOGIC_VECTOR (0 to N - 1);
           EN : in  STD_LOGIC;
           MASK : in  STD_LOGIC_VECTOR (0 to N - 1);
           O : out  STD_LOGIC_VECTOR (0 to N - 1));
end ErrorGeneratorForTesting;

architecture Behavioral of ErrorGeneratorForTesting is
begin
   O <= (I xor MASK) when EN = '1' else I;
end Behavioral;
