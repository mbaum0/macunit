library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top_MAC is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Test_Enable : in STD_LOGIC;
           B : in STD_LOGIC_VECTOR (15 downto 0);
           C : in STD_LOGIC_VECTOR (15 downto 0);
           MAC_Out : out STD_LOGIC_VECTOR (31 downto 0);
           Test_Results : out STD_LOGIC);
end top_MAC;

architecture Behavioral of top_MAC is

component  MISR_32 is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Enable : in STD_LOGIC;
           Din : in STD_LOGIC_VECTOR (31 downto 0);
           Signature : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component LFSR_16 is
    Generic (
           Reset_Vect : std_logic_vector(15 downto 0) := X"0001"
    );
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Enable : in STD_LOGIC;
           Bit_Pattern : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component MAC_Unit is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           B : in STD_LOGIC_VECTOR (15 downto 0);
           C : in STD_LOGIC_VECTOR (15 downto 0);
           Dout : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal sLFSRB, sLFSRC : std_logic_vector(15 downto 0) := (others => '0');
signal sMacB, sMacC   : std_logic_vector(15 downto 0) := (others => '0');
signal sMacOut, sSignature : std_logic_vector(31 downto 0) := (others => '0');

begin

LFSR_B_inst:LFSR_16
generic map (
    Reset_Vect => X"0001"
)
port map ( 
    Clk         => Clk, 
    Rst         => Rst,
    Enable      => Test_Enable,
    Bit_Pattern => sLFSRB
);

LFSR_C_inst:LFSR_16
generic map (
    Reset_Vect => X"1000"
)
port map ( 
    Clk         => Clk, 
    Rst         => Rst,
    Enable      => Test_Enable,
    Bit_Pattern => sLFSRC
);

process(Test_Enable, sLFSRB, sLFSRC, B, C)
begin
    case Test_Enable is
      when '1' =>
        sMacB <= sLFSRB;
        sMacC <= sLFSRC;
      when others =>
        sMacB <= B;
        sMacC <= C;
    end case;
end process;

MAC_Unit_inst:MAC_Unit
port map ( 
    Clk  => Clk,
    Rst  => Rst,
    B    => sMacB,
    C    => sMacC,
    Dout => sMacOut
);

MAC_Out <= sMacOut;

MISR_inst:MISR_32
port map ( 
    Clk       => Clk,
    Rst       => Rst,
    Enable    => Test_Enable,
    Din       => sMacOut,
    Signature => sSignature
);


Test_Results <= '1' when sSignature = X"2E036557" else '0';


end Behavioral;
