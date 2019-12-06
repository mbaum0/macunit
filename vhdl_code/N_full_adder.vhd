----------------------------------------------------------------------------------
-- Company: RIT
-- Engineer: Matthew Toro
-- Create Date:    18:38:00 03/01/2017 
-- Module Name:    N_full_adder - structural
-- Project Name: Lab_3
-- Target Devices: Nexys 3
-- Description: N-bit full adder/subtractor
-- Adds if Mode = 0, Subtracts if Mode = 1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


-- Entitiy Declaration
entity N_full_adder is
		Generic( N	: integer:= 4);
		Port(	A, B	: in std_logic_vector(N-1 downto 0);
				Mode	: in std_logic;
				Sum	: out std_logic_vector(N-1 downto 0);
			 Cout, V : out std_logic);
end N_full_adder;

-- Architecture Declaration
architecture Structural of N_full_adder is

-- Component Declaration
Component full_adder is
	Port(	A, B, Cin : in std_logic;
			Sum, Cout :	out std_logic);
end component;

-- Signal Declaration
signal xor_B : std_logic_vector(N-1 downto 0) := (others => '0');
signal Couts : std_logic_vector(N-1 downto 0) := (others => '0');


begin	
		-- Negates B if Mode = 1
		xor_proc: process (Mode, B) begin
			for i in 0 to N-1 loop			
				xor_B(i) <= Mode xor B(i);
			end loop;
		end process;
		
		-- First Adder, recieves Cin from Mode input.
		adder_0: full_adder port map(
			  A => A(0),
			  B => xor_B(0),
			Cin => Mode,
			Sum => Sum(0),
			Cout => Couts(0)
		);
		
		-- Generate loop, creates all other N-1 adders
		adders : for i in 1 to N-1 generate
			adder_i: full_adder port map(
				A => A(i),
				B => xor_B(i),
			 Cin => Couts(i-1),
			 Sum => Sum(i),
			Cout => Couts(i)
			);
		end generate;
		
		-- Assign Last Cout
		Cout <= Couts(N-1);
		
		-- Determine Overflow
		V <= Couts(N-1) xor Couts(N-2);
		
		
end Structural;

