----------------------------------------------------------------------------------
-- Company: RIT
-- Engineer: Matthew Toro-- Create Date:    18:24:39 03/01/2017 
-- Module Name:    full_adder - Dataflow
-- Project Name: Lab_3
-- Target Devices: Nexys 3
-- Description: Singular full adder
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
entity full_adder is
	Port(	A, B, Cin : in std_logic;
			Sum, Cout :	out std_logic);
end full_adder;

-- Architecture Delcaration
architecture Dataflow of full_adder is

begin
		Sum	<= A xor B xor Cin;
		Cout	<= (A and B) or (A and Cin) or (B and Cin);

end Dataflow;

