library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LFSR_16 is
    Generic (
           Reset_Vect : std_logic_vector(15 downto 0) := X"0001"
    );
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Enable : in STD_LOGIC;
           Bit_Pattern : out STD_LOGIC_VECTOR (15 downto 0));
end LFSR_16;

architecture Behavioral of LFSR_16 is


signal xor_input : std_logic := '0';
signal pattern : std_logic_vector(15 downto 0) := (others => '0');

begin

xor_input <= pattern(0) xor pattern(1) xor pattern(2) xor pattern(4) xor pattern(15);

process(Clk, Rst)
begin
    if Rst = '1' then
        pattern <= Reset_Vect;
    elsif rising_edge(clk) then
        case enable is
            when '1' =>
                pattern <= xor_input & pattern(15 downto 1);
            when others =>
                pattern <= pattern;
        end case;
    end if;
end process;

Bit_Pattern <= pattern;

end Behavioral;
