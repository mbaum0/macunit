library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity top_MAC_tb is
end;

architecture bench of top_MAC_tb is

  component top_MAC
      Port ( Clk : in STD_LOGIC;
             Rst : in STD_LOGIC;
             Test_Enable : in STD_LOGIC;
             B : in STD_LOGIC_VECTOR (15 downto 0);
             C : in STD_LOGIC_VECTOR (15 downto 0);
             MAC_Out : out STD_LOGIC_VECTOR (31 downto 0);
             Test_Results : out STD_LOGIC);
  end component;

  signal Clk: STD_LOGIC;
  signal Rst: STD_LOGIC;
  signal Test_Enable: STD_LOGIC;
  signal B: STD_LOGIC_VECTOR (15 downto 0);
  signal C: STD_LOGIC_VECTOR (15 downto 0);
  signal MAC_Out: STD_LOGIC_VECTOR (31 downto 0);
  signal Test_Results: STD_LOGIC;

  constant clk_period: time := 10 ns;
  signal stop_the_clock: boolean;

  type tVectArray is array (0 to 9) of integer range 0 to 65535;
  
begin

  uut: top_MAC port map ( Clk          => Clk,
                          Rst          => Rst,
                          Test_Enable  => Test_Enable,
                          B            => B,
                          C            => C,
                          MAC_Out      => MAC_Out,
                          Test_Results => Test_Results );

  stimulus: process
    variable VectArrayB : tVectArray := (0, 10, 20, 30, 40, 50, 60, 70, 80, 90);
    variable VectArrayC : tVectArray := (10, 20, 30, 40, 50, 60, 70, 80, 90, 100);
  begin
    
    B <= (others => '0');
    C <= (others => '0');
    Test_Enable <= '0';

    Rst <= '1';
    wait for clk_period*20;
    Rst <= '0';
    wait for clk_period*5/4;

    -- Put test bench stimulus code here
    for i in 0 to 9 loop
        
        B <= std_logic_vector(to_unsigned(VectArrayB(i), 16));
        C <= std_logic_vector(to_unsigned(VectArrayC(i), 16));
        wait for clk_period;
        
    end loop;
    
    B <= (others => '0');
    C <= (others => '0');
    wait for clk_period;    

    Test_Enable <= '1';
    Rst <= '1';
    wait for clk_period*5;
    Rst <= '0';
    wait for clk_period*110;
    Test_Enable <= '0';
    wait for clk_period*10;


    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      Clk <= '0', '1' after clk_period / 2;
      wait for clk_period;
    end loop;
    wait;
  end process;
end;