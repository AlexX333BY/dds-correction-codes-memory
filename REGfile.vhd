library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGfile is
    Generic ( A : integer := 8;
              INITREG : STD_LOGIC_VECTOR := "00000000");
    Port ( INIT : in  STD_LOGIC;
           WDP : in  STD_LOGIC_VECTOR (INITREG'range);
           WA : in  STD_LOGIC_VECTOR (A - 1 downto 0);
           RA : in  STD_LOGIC_VECTOR (A - 1 downto 0);
           WE : in  STD_LOGIC;
           RDP : out  STD_LOGIC_VECTOR (INITREG'range));
end REGfile;

architecture Structural of REGfile is

   component REGn
      Generic ( INITREG : STD_LOGIC_VECTOR := INITREG);
      Port ( INIT : in  STD_LOGIC;
             Din : in  STD_LOGIC_VECTOR (INITREG'range);
             EN : in  STD_LOGIC;
             CLK : in  STD_LOGIC;
             OE : in  STD_LOGIC;
             Dout : out  STD_LOGIC_VECTOR (INITREG'range));
   end component;

   component AD
      Generic ( a : integer := A);
      Port ( I : in  STD_LOGIC_VECTOR (a - 1 downto 0);
             O : out  STD_LOGIC_VECTOR (0 to 2 ** a - 1));
   end component;

   signal write_onehot, read_onehot : STD_LOGIC_VECTOR (0 to 2 ** a - 1);

begin
   REGF_WAD: AD port map (I => WA, O => write_onehot);
   REGF_RAD: AD port map (I => RA, O => read_onehot);
   REGF_REGS: for i in 0 to 2 ** A - 1 generate
      REGF_REG: REGn port map (INIT => INIT, 
                               Din => WDP,
                               EN => write_onehot(i),
                               CLK => WE,
                               OE => read_onehot(i),
                               Dout => RDP
                              );
   end generate;
end Structural;
