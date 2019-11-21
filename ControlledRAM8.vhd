library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlledRAM8 is
    Generic ( ADDR_LENGTH : integer := 2);
    Port ( CLK : in  STD_LOGIC;
           WR : in  STD_LOGIC;
           ADDR : in  STD_LOGIC_VECTOR (ADDR_LENGTH - 1 downto 0);
           DATA : inout  STD_LOGIC_VECTOR (0 to 7);
           CONTROL_BITS : out  STD_LOGIC_VECTOR (0 to 3));
end ControlledRAM8;

architecture Structural of ControlledRAM8 is
   component RAM
      Generic ( WORD_LENGTH : integer := 8;
                ADDR_LENGTH : integer := ADDR_LENGTH);
      Port ( CLK : in  STD_LOGIC;
             WR : in  STD_LOGIC;
             ADDR : in  STD_LOGIC_VECTOR (ADDR_LENGTH - 1 downto 0);
             DATA : inout  STD_LOGIC_VECTOR (0 to WORD_LENGTH - 1));
   end component;

   component HammingEncoder8
      Port ( RAM_WR : in  STD_LOGIC;
             CLK : in  STD_LOGIC;
             I : in  STD_LOGIC_VECTOR (0 to 7);
             O : out  STD_LOGIC_VECTOR (0 to 3));
   end component;
begin
   CR_RAM: RAM port map (CLK => CLK, WR => WR, ADDR => ADDR, DATA => DATA);
   CR_HAM: HammingEncoder8 port map (CLK => CLK, RAM_WR => WR, I => DATA, O => CONTROL_BITS);
end Structural;
