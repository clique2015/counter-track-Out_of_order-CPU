
--------------------------------------------------------------------------------
-- PROJECTFPGA.COM
--------------------------------------------------------------------------------
-- NAME:    register.vhd
--------------------------------------------------------------------------------
-- AUTHORS: Ezeuko Emmanuel <ezeuko.arinze@projectfpga.com>
--------------------------------------------------------------------------------
-- WEBSITE: https://projectfpga.com/iosoc
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- brainio
--------------------------------------------------------------------------------
-- Copyright (C) 2020 projectfpga.com
--
-- This source file is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This source file is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity rd_compare is

port(
  clock, reset, enable							  : in   unsigned(0 downto 0);
  rd, rs1_check, rs2_check, addr  			  : in   unsigned(2 downto 0);  
  setE, setF, setG         					  : out  unsigned(0 downto 0);
  setA, setB, setc, setD						  : out  unsigned(0 downto 0));

end entity;

architecture structure of rd_compare is
	signal reg1, reg2, reg3, reg4, reg5, reg6, reg7   : unsigned(2 downto 0);
	
begin

----------------------------------------------	
-- store to register
----------------------------------------------	
process(reset, clock)
	begin
	  if (reset= "1") then		  
			reg1	  <= "000";
			reg2    <= "000";
			reg3	  <= "000";
			reg4    <= "000";
			reg5	  <= "000";
			reg6    <= "000";
			reg7	  <= "000";
	
	  elsif (clock'event and clock= "1") then 
			if (enable = "1") then	 
			  case addr is
					when "001" => reg1 <= rd;
					when "010" => reg2 <= rd;
					when "011" => reg3 <= rd;
					when "100" => reg4 <= rd;
					when "101" => reg5 <= rd;
					when "110" => reg6 <= rd;
					when "111" => reg7 <= rd;
					when others      => null ;
			  end case;

		end if;			
		end if;
end process;			
----------------------------------------------	

----------------------------------------------	


	setA <= "1" when enable = "1" and (rs1_check = reg1 or rs2_check = reg1) else "0";	
	setB <= "1" when enable = "1" and (rs1_check = reg2 or rs2_check = reg2) else "0";	
	setC <= "1" when enable = "1" and (rs1_check = reg3 or rs2_check = reg3) else "0";	
	setD <= "1" when enable = "1" and (rs1_check = reg4 or rs2_check = reg4) else "0";	
	setE <= "1" when enable = "1" and (rs1_check = reg5 or rs2_check = reg5) else "0";	
	setF <= "1" when enable = "1" and (rs1_check = reg6 or rs2_check = reg6) else "0";	
	setG <= "1" when enable = "1" and (rs1_check = reg7 or rs2_check = reg7) else "0";
			
----------------------------------------------

end structure;