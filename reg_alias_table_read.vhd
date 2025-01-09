--------------------------------------------------------------------------------
-- PROJECTFPGA.COM
--------------------------------------------------------------------------------
-- NAME:    Fifo-In-First-out FIFO.vhd
--------------------------------------------------------------------------------
-- AUTHORS: Ezeuko Emmanuel <ezeuko.arinze@projectfpga.com>
--------------------------------------------------------------------------------
-- WEBSITE: https://projectfpga.com/iosoc
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- BrainIO
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

entity read_count is

port(
  CLK, RESET, enable 		 : in  unsigned(0 downto 0);
  rs1_check, rs2_check		 : in  unsigned(2 downto 0);
  rs2, rs1 , rd				 : in  unsigned(2 downto 0);
  rd_count              	 : out unsigned(2 downto 0));
 
end entity;

architecture structure of read_count is
	signal reg5, reg6, reg7, reg4 : unsigned(2 downto 0);
	signal reg1, reg2, reg3 		: unsigned(2 downto 0);

		
begin

process(rd)
begin
       if rd = "001" then rd_count <= reg1;
    elsif rd = "010" then rd_count <= reg2;
    elsif rd = "011" then rd_count <= reg3;
    elsif rd = "100" then rd_count <= reg4;
    elsif rd = "101" then rd_count <= reg5;
    elsif rd = "110" then rd_count <= reg6;
    elsif rd = "111" then rd_count <= reg7;
    else
        rd_count <= (others => '0'); -- Default case
    end if;
end process;

	
	process (CLK, RESET)
   begin
        if (reset = "1") then
            reg1 <= "000";				
	         reg2 <= "000";			
            reg3 <= "000";
				reg4 <= "000";
            reg5 <= "000";				
	         reg6 <= "000";			
            reg7 <= "000";	
				
        elsif (CLK'event and CLK = "1") then 
			if (enable = "1") then
			
			if(rs1_check = "001" or rs2_check = "001" or rs1 = "001" or rs2 = "001") then
				if((rs1_check = "001" or rs2_check = "001") and (rs1 = "001" or rs2 = "001")) then
					reg1 <= reg1;
				elsif(rs1_check = "001" or rs2_check = "001") then
					reg1 <= reg1 - 1;
				else
					reg1 <= reg1 + 1;
				end if;
			end if;
			
			if(rs1_check = "010" or rs2_check = "010" or rs1 = "010" or rs2 = "010") then
				if((rs1_check = "010" or rs2_check = "010") and (rs1 = "010" or rs2 = "010")) then
					reg2 <= reg2;
				elsif(rs1_check = "010" or rs2_check = "010") then
					reg2 <= reg2 - 1;
				else
					reg2 <= reg2 + 1;
				end if;
			end if;			
			
	if(rs1_check = "011" or rs2_check = "011" or rs1 = "011" or rs2 = "011") then
				if((rs1_check = "011" or rs2_check = "011") and (rs1 = "011" or rs2 = "011")) then
					reg3 <= reg3;
				elsif(rs1_check = "011" or rs2_check = "011") then
					reg3 <= reg3 - 1;
				else
					reg3 <= reg3 + 1;
				end if;
			end if;
	
	if(rs1_check = "100" or rs2_check = "100" or rs1 = "100" or rs2 = "100") then
				if((rs1_check = "100" or rs2_check = "100") and (rs1 = "100" or rs2 = "100")) then
					reg4 <= reg4;
				elsif(rs1_check = "100" or rs2_check = "100") then
					reg4 <= reg4 - 1;
				else
					reg4 <= reg4 + 1;
				end if;
			end if;	

	if(rs1_check = "101" or rs2_check = "101" or rs1 = "101" or rs2 = "101") then
				if((rs1_check = "101" or rs2_check = "101") and (rs1 = "101" or rs2 = "101")) then
					reg5 <= reg5;
				elsif(rs1_check = "101" or rs2_check = "101") then
					reg5 <= reg5 - 1;
				else
					reg5 <= reg5 + 1;
				end if;
			end if;	

	if(rs1_check = "110" or rs2_check = "110" or rs1 = "110" or rs2 = "110") then
				if((rs1_check = "110" or rs2_check = "110") and (rs1 = "110" or rs2 = "110")) then
					reg6 <= reg6;
				elsif(rs1_check = "110" or rs2_check = "110") then
					reg6 <= reg6 - 1;
				else
					reg6 <= reg6 + 1;
				end if;
			end if;	

	if(rs1_check = "111" or rs2_check = "111" or rs1 = "111" or rs2 = "111") then
				if((rs1_check = "111" or rs2_check = "111") and (rs1 = "111" or rs2 = "111")) then
					reg7 <= reg7;
				elsif(rs1_check = "111" or rs2_check = "111") then
					reg7 <= reg7 - 1;
				else
					reg7 <= reg7 + 1;
				end if;
			end if;	
		
		end if;
				
  end if;
  end process;
	
end structure;