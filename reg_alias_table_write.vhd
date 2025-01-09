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

entity write_count is

port(
  CLK, RESET, enable 		 		: in  unsigned(0 downto 0);
  rd_check, rd, rs2, rs1	 		: in  unsigned(2 downto 0);
  rs1_count, rs2_count				: out unsigned(2 downto 0));
 
end entity;

architecture structure of write_count is
	signal reg5, reg6, reg7, reg4 : unsigned(2 downto 0);
	signal reg1, reg2, reg3 		: unsigned(2 downto 0);

		
begin

process(rs1, rs2)
begin
	 
       if rs1 = "001" then rs1_count <= reg1;
    elsif rs1 = "010" then rs1_count <= reg2;
    elsif rs1 = "011" then rs1_count <= reg3;
    elsif rs1 = "100" then rs1_count <= reg4;
    elsif rs1 = "101" then rs1_count <= reg5;
    elsif rs1 = "110" then rs1_count <= reg6;
    elsif rs1 = "111" then rs1_count <= reg7;
    else
        rs1_count <= (others => '0'); -- Default case
    end if;	 
	 
       if rs2 = "001" then rs2_count <= reg1;
    elsif rs2 = "010" then rs2_count <= reg2;
    elsif rs2 = "011" then rs2_count <= reg3;
    elsif rs2 = "100" then rs2_count <= reg4;
    elsif rs2 = "101" then rs2_count <= reg5;
    elsif rs2 = "110" then rs2_count <= reg6;
    elsif rs2 = "111" then rs2_count <= reg7;
    else
        rs2_count <= (others => '0'); -- Default case
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
			
			if(rd_check = "001" or rd = "001") then
				if(rd_check = "001" and rd = "001") then
					reg1 <= reg1;
				elsif(rd_check = "001") then
					reg1 <= reg1 - 1;
				else
					reg1 <= reg1 + 1;
				end if;
			end if;
			
			if(rd_check = "010" or rd = "010") then
				if(rd_check = "010" and rd = "010") then
					reg2 <= reg2;
				elsif(rd_check = "010") then
					reg2 <= reg2 - 1;
				else
					reg2 <= reg2 + 1;
				end if;
			end if;			
			
	if(rd_check = "011" or rd = "011") then
				if(rd_check = "011" and rd = "011") then
					reg3 <= reg3;
				elsif(rd_check = "011") then
					reg3 <= reg3 - 1;
				else
					reg3 <= reg3 + 1;
				end if;
			end if;
	
	if(rd_check = "100" or rd = "100") then
				if(rd_check = "100" and rd = "100") then
					reg4 <= reg4;
				elsif(rd_check = "100") then
					reg4 <= reg4 - 1;
				else
					reg4 <= reg4 + 1;
				end if;
			end if;	

	if(rd_check = "101" or rd = "101") then
				if(rd_check = "101" and rd = "101") then
					reg5 <= reg5;
				elsif(rd_check = "101") then
					reg5 <= reg5 - 1;
				else
					reg5 <= reg5 + 1;
				end if;
			end if;	

	if(rd_check = "110" or rd = "110") then
				if(rd_check = "110" and rd = "110") then
					reg6 <= reg6;
				elsif(rd_check = "110") then
					reg6 <= reg6 - 1;
				else
					reg6 <= reg6 + 1;
				end if;
			end if;	

	if(rd_check = "111" or rd = "111") then
				if(rd_check = "111" and rd = "111") then
					reg7 <= reg7;
				elsif(rd_check = "111") then
					reg7 <= reg7 - 1;
				else
					reg7 <= reg7 + 1;
				end if;
			end if;	
		
		end if;
				
  end if;
  end process;
	
end structure;