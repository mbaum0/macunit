library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity MISR_32_tb is
end;

architecture bench of MISR_32_tb is

  component MISR_32
      Port ( Clk : in STD_LOGIC;
             Rst : in STD_LOGIC;
             Enable : in STD_LOGIC;
             Din : in STD_LOGIC_VECTOR (31 downto 0);
             Signature : out STD_LOGIC_VECTOR (31 downto 0));
  end component;

  signal Clk: STD_LOGIC;
  signal Rst: STD_LOGIC;
  signal Enable: STD_LOGIC;
  signal Din: STD_LOGIC_VECTOR (31 downto 0);
  signal Signature: STD_LOGIC_VECTOR (31 downto 0);

  constant clk_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: MISR_32 port map ( Clk       => Clk,
                          Rst       => Rst,
                          Enable    => Enable,
                          Din       => Din,
                          Signature => Signature );

  stimulus: process
  begin
  
    -- Put initialisation code here
    Enable <= '0';
    Din <= (others => '0');
    Rst <= '1';
    wait for clk_period;
    Rst <= '0';
    wait for clk_period*5/4;

    -- Put test bench stimulus code here
    Enable <= '1';
    wait for clk_period;
    
    for i in 1 to 100 loop
        Din <= std_logic_vector(to_unsigned(i, 32));
        wait for clk_period;
    end loop;

    Enable <= '0';
    wait for clk_period*5;
    
    Din <= (others => '0');
    Rst <= '1';
    wait for clk_period;
    
    Rst <= '0';
    Enable <= '1';
    wait for clk_period;
     
    for i in 1 to 100 loop
        Din <= std_logic_vector(to_unsigned(i, 32));
        wait for clk_period;
    end loop;
    
    Enable <= '0';
    wait for clk_period;

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clk_period / 2;
      wait for clk_period;
    end loop;
    wait;
  end process;

end;