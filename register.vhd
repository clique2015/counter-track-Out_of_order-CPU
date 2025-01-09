
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity registers is

port(
  clock, reset,enable, m_enable  								 : in unsigned(0 downto 0);
  reg_sel, regA_sel, regB_sel, regC_sel, mem_sel          : in  unsigned(2 downto 0);  
  reg_in, mem_in                                          : in  unsigned(15 downto 0);
  reg_0, reg_1, reg_2, reg_3, reg_4, reg_5, reg_6, reg_7  : out unsigned(15 downto 0);
  regA_out, regB_out, regC_out					  				 : out unsigned(15 downto 0));

end entity;

architecture structure of registers is
	signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7   : unsigned(15 downto 0);
	
begin

----------------------------------------------	
-- store to register
----------------------------------------------	
process(reset, clock)
	begin
	  if (reset =  "1") then		  
			reg0    <= x"0000";
			reg1	  <= x"0000";
			reg2    <= x"0000";
			reg3	  <= x"0000";
			reg4    <= x"0000";
			reg5	  <= x"0000";
			reg6    <= x"0000";
			reg7	  <= x"0000";
	
	  elsif (clock'event and clock =  "1") then 
			if (enable = "1") then	 
			  case reg_sel is
					when "000" => reg0 <= reg_in;
					when "001" => reg1 <= reg_in;
					when "010" => reg2 <= reg_in;
					when "011" => reg3 <= reg_in;
					when "100" => reg4 <= reg_in;
					when "101" => reg5 <= reg_in;
					when "110" => reg6 <= reg_in;
					when "111" => reg7 <= reg_in;
					when others      => null ;
			  end case;
			else
			if (m_enable = "1") then	 
			  case mem_sel is
					when "000" => reg0 <= mem_in;
					when "001" => reg1 <= mem_in;
					when "010" => reg2 <= mem_in;
					when "011" => reg3 <= mem_in;
					when "100" => reg4 <= mem_in;
					when "101" => reg5 <= mem_in;
					when "110" => reg6 <= mem_in;
					when "111" => reg7 <= mem_in;
					when others      => null ;
			  end case;
			 end if;
		end if;			
		end if;
end process;			
----------------------------------------------	
-- reading from the bank
----------------------------------------------	
  process(regA_sel, regB_sel, regC_sel)
   begin
	  case regA_sel is
			when "000" => regA_out <= reg0;
			when "001" => regA_out <= reg1;
			when "010" => regA_out <= reg2;
			when "011" => regA_out <= reg3;
			when "100" => regA_out <= reg4;
			when "101" => regA_out <= reg5;
			when "110" => regA_out <= reg6;
			when "111" => regA_out <= reg7;
			when others      => null ;
	  end case;	

	  case regB_sel is
			when "000" => regB_out <= reg0;
			when "001" => regB_out <= reg1;
			when "010" => regB_out <= reg2;
			when "011" => regB_out <= reg3;
			when "100" => regB_out <= reg4;
			when "101" => regB_out <= reg5;
			when "110" => regB_out <= reg6;
			when "111" => regB_out <= reg7;
			when others      => null ;
	  end case;	

	  case regC_sel is
			when "000" => regC_out <= reg0;
			when "001" => regC_out <= reg1;
			when "010" => regC_out <= reg2;
			when "011" => regC_out <= reg3;
			when "100" => regC_out <= reg4;
			when "101" => regC_out <= reg5;
			when "110" => regC_out <= reg6;
			when "111" => regC_out <= reg7;
			when others      => null ;
	  end case;
	  
  end process;		

	reg_0 <= reg0;
	reg_1 <= reg1;
	reg_2 <= reg2;
	reg_3 <= reg3;
	reg_4 <= reg4;
	reg_5 <= reg5;
	reg_6 <= reg6;
	reg_7 <= reg7;
			
----------------------------------------------

end structure;