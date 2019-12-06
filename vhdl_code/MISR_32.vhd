library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MISR_32 is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Enable : in STD_LOGIC;
           Din : in STD_LOGIC_VECTOR (31 downto 0);
           Signature : out STD_LOGIC_VECTOR (31 downto 0));
end MISR_32;

architecture Behavioral of MISR_32 is

signal sig, xor_sig : std_logic_vector(31 downto 0);

begin

-- Xors the signature and input into intermideate value
Xor_Proc: process(Din, sig) is
begin
    xor_sig(31) <= Din(31) xor sig(0) xor sig(1) xor sig(5) xor sig(6);
    for i in 30 downto 0 loop
        xor_sig(i) <= Din(i) xor sig(i+1);
    end loop;
end process;


-- Assigns the intermidate shift value on the clk edge if enable is high
Shift_Proc: process(Clk, Rst) is
begin
    if Rst = '1' then
        sig <= (others => '0');
    elsif rising_edge(clk) then
        case Enable is
            when '1' =>
                sig <= xor_sig;
            when others =>
                sig <= sig;
        end case;
    end if;
end process;

Signature <= sig;

end Behavioral;
