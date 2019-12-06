----------------------------------------------------------------------------------
-- Company: RIT
-- Engineer: Matthew Toro
-- Create Date:    20:37:58 03/12/2017 
-- Module Name:    N_multiplier - Behavioral 
-- Project Name: Lab_3
-- Target Devices: Nexys 3
-- Description: N-bit multiplier
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity N_multiplier is
	Generic( N : integer := 16);
	Port( A, B : in std_logic_vector(N/2-1 downto 0);
			product : out std_logic_vector(N-1 downto 0));
end N_multiplier;

architecture Structural of N_multiplier is

Component full_adder is
	Port(	A, B, Cin : in std_logic;
			Sum, Cout :	out std_logic);
end Component;

type and_array is array(N/2-1 downto 0) of std_logic_vector(N/2-1 downto 0);
signal ands : and_array;

type cout_array is array(N/2-2 downto 0) of std_logic_vector(N/2-1 downto 0);
signal couts : cout_array;

type sum_array is array(N/2-2 downto 0) of std_logic_vector(N/2-1 downto 0);
signal sums : sum_array;


begin

	ands_proc: process (A, B) begin
		for row in 0 to N/2-1 loop
			for col in 0 to N/2-1 loop
				ands(row)(col) <= B(row) and A(col);
			end loop;
		end loop;
	end process;
	
	product_proc: process (ands, sums, couts) begin
		product(0) <= ands(0)(0);
		
		for i in 1 to N/2-1 loop
			product(i) <= sums(i-1)(0);
		end loop;
		
		for i in N/2 to N-2 loop
			product(i) <= sums(N/2-2)(i-(N/2-1));
		end loop;
		
		product(N-1) <= couts(N/2-2)(N/2-1);

	end process;
	
	
	
	-- First Row. Unique because of sum inputs
	Row0: for col in 0 to N/2-1 generate
		
		Col0: if col = 0 generate
			fa_00: full_adder port map(
				A => ands(0)(col+1),		-- special if row == 0
				B => ands(1)(col),	
				Cin => '0',					-- special if col == 0
				Sum => sums(0)(col),
				Cout => couts(0)(col)
			);
		end generate;
		
		
		Col_last: if col = N/2-1 generate
			fa_N: full_adder port map(
				A => '0',		-- special if row == 0
				B => ands(1)(col),	
				Cin => couts(0)(col-1),
				Sum => sums(0)(col),
				Cout => couts(0)(col)
			);
		end generate;
		
		
		
		Colj: if col > 0 and col < N/2-1 generate
			fa_0j: full_adder port map(
				A => ands(0)(col+1),		-- special if row == 0
				B => ands(1)(col),	
				Cin => couts(0)(col-1),
				Sum => sums(0)(col),
				Cout => couts(0)(col)
			);
		end generate;
		
	end generate;
	
	-- First Column. Unique because of carry in input
	Col0: for row in 1 to N/2-2 generate
		fa_i0: full_adder port map(
			A => sums(row-1)(1),		
			B => ands(row+1)(0),	
			Cin => '0',					-- special if col == 0
			Sum => sums(row)(0),
			Cout => couts(row)(0)
		);
	end generate;
	
	
	-- Last Column. Unique because of sum inputs
	Col_last: for row in 1 to N/2-2 generate
		fa_last: full_adder port map(
			A => couts(row-1)(N/2-1),	-- special for last column. 
			B => ands(row+1)(N/2-1),	
			Cin => couts(row)(N/2-2),					
			Sum => sums(row)(N/2-1),
			Cout => couts(row)(N/2-1)
		);
	end generate;
	
	
	-- Others
	Rowi: for row in 1 to N/2-2 generate
		Colj: for col in 1 to N/2-2 generate
			fa_ij: full_adder port map(
				A => sums(row-1)(col+1),		
				B => ands(row+1)(col),	
				Cin => couts(row)(col-1),					
				Sum => sums(row)(col),
				Cout => couts(row)(col)
			);
		end generate;
	end generate;
	
	
	
	

	
end Structural;

