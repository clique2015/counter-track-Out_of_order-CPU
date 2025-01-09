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

entity instr_buffer is

port(
  CLK, RESET, enable 		 	 : in  unsigned(0  downto 0);
  addr_in, addr_out            : in  unsigned(2  downto 0);
  instr_in                		 : in  unsigned(31 downto 0);  
  instr_out                    : out unsigned(31 downto 0));
 
end entity;

architecture structure of instr_buffer is
	signal reg5, reg6, reg7, data       : unsigned(31 downto 0);
	signal reg0, reg1, reg2, reg3, reg4 : unsigned(31 downto 0);
	signal instr_reg                   	: unsigned(31 downto 0);
		
begin

    process(addr_out)
    begin
        case addr_out is
				when "000" => instr_out <= reg0;
				when "001" => instr_out <= reg1;
				when "010" => instr_out <= reg2;
				when "011" => instr_out <= reg3;
				when "100" => instr_out <= reg4;
				when "101" => instr_out <= reg5;
				when "110" => instr_out <= reg6;
				when "111" => instr_out <= reg7;
            when others      => null ;
        end case;
    end process;

	
	process (CLK, RESET)
   begin
        if (reset = "1") then
            reg0 <= x"00000000";
            reg1 <= x"00000000";				
	         reg2 <= x"00000000";			
            reg3 <= x"00000000";
				reg4 <= x"00000000";
            reg5 <= x"00000000";				
	         reg6 <= x"00000000";			
            reg7 <= x"00000000";	
				
        elsif (CLK'event and CLK = "1") then 
			if (enable = "1") then
				case addr_in is
					when "000" => reg0 <= instr_reg;
					when "001" => reg1 <= instr_reg;
					when "010" => reg2 <= instr_reg;
					when "011" => reg3 <= instr_reg;
					when "100" => reg4 <= instr_reg;
					when "101" => reg5 <= instr_reg;
					when "110" => reg6 <= instr_reg;
					when "111" => reg7 <= instr_reg;
					when others      => null ;
					end case;

			end if;

			instr_reg <= instr_in;	
				
  end if;
  end process;
	
end structure;