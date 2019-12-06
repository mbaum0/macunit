library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MAC_Unit is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           B : in STD_LOGIC_VECTOR (15 downto 0);
           C : in STD_LOGIC_VECTOR (15 downto 0);
           Dout : out STD_LOGIC_VECTOR (31 downto 0));
end MAC_Unit;

architecture Behavioral of MAC_Unit is

Component  N_multiplier is
	Generic( N : integer := 16 );
	Port   ( A, B    : in std_logic_vector(N/2-1 downto 0);
		     product : out std_logic_vector(N-1 downto 0)
		   );
end component;

Component N_full_adder is
    Generic( N	: integer:= 4);
	Port   ( A, B	: in std_logic_vector(N-1 downto 0);
			 Mode	: in std_logic;
			 Sum	: out std_logic_vector(N-1 downto 0);
			 Cout, V : out std_logic
		   );
end component;


signal sProduct, sMac, sSum : std_logic_vector(31 downto 0) := (others => '0');

begin

Mult_inst:N_multiplier
generic map(
    N => 32
)
port map(
    A       => B,
    B       => C,
    product => sProduct
);

Addr_inst:N_full_adder
generic map(
    N => 32
)
port map(
    A => sProduct,
    B => sMac,
    Mode => '0',
    Sum => sSum
);


MAC_Reg_Proc:process(Clk, Rst)
begin
    if Rst = '1' then
        sMac <= (others => '0');
    elsif rising_edge(Clk) then
        sMac <= sSum;
    end if;
end process;

Dout <= sMac;

end Behavioral;
