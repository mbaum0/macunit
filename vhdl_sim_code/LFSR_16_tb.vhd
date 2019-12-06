library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity LFSR_16_tb is
end;

architecture bench of LFSR_16_tb is

  component LFSR_16
      Generic (
             Reset_Vect : std_logic_vector(15 downto 0) := X"0001"
      );
      Port ( Clk : in STD_LOGIC;
             Rst : in STD_LOGIC;
             Enable : in STD_LOGIC;
             Bit_Pattern : out STD_LOGIC_VECTOR (15 downto 0));
  end component;

  signal Clk: STD_LOGIC;
  signal Rst: STD_LOGIC;
  signal Enable: STD_LOGIC;
  signal Bit_Pattern: STD_LOGIC_VECTOR (15 downto 0);

  constant clk_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: LFSR_16 generic map ( Reset_Vect  => X"003A" )
                  port map ( Clk         => Clk,
                             Rst         => Rst,
                             Enable      => Enable,
                             Bit_Pattern => Bit_Pattern );

  stimulus: process
  begin
  
    -- Put initialisation code here
    enable <= '0';

    Rst <= '1';
    wait for clk_period;
    Rst <= '0';
    wait for clk_period*5/4;

    enable <= '1';
    
    wait for clk_period*65540;

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