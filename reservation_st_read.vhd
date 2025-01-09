
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


entity rs_compare is

port(
  clock, reset,enable		: in   unsigned(0 downto 0);
  addr, check_reg, reg_in  : in   unsigned(2 downto 0);  
  setE, setF, setG         : out  unsigned(0 downto 0);
  setA, setB, setc, setD	: out  unsigned(0 downto 0));

end entity;

architecture structure of rs_compare is
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
					when "001" => reg1 <= reg_in;
					when "010" => reg2 <= reg_in;
					when "011" => reg3 <= reg_in;
					when "100" => reg4 <= reg_in;
					when "101" => reg5 <= reg_in;
					when "110" => reg6 <= reg_in;
					when "111" => reg7 <= reg_in;
					when others      => null ;
			  end case;

		end if;			
		end if;
end process;			
----------------------------------------------	

----------------------------------------------	


	setA <= "1" when enable = "1" and check_reg = reg1 else "0";	
	setB <= "1" when enable = "1" and check_reg = reg2 else "0";	
	setC <= "1" when enable = "1" and check_reg = reg3 else "0";	
	setD <= "1" when enable = "1" and check_reg = reg4 else "0";	
	setE <= "1" when enable = "1" and check_reg = reg5 else "0";	
	setF <= "1" when enable = "1" and check_reg = reg6 else "0";	
	setG <= "1" when enable = "1" and check_reg = reg7 else "0";
			
----------------------------------------------

end structure;