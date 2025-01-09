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

entity output_buffer is

port(
  CLK, RESET, push_mem_in, push_reg_in   : in  unsigned(0 downto 0);
  mem_in, reg_in                         : in  unsigned(2 downto 0);
  FIFO_OUT                               : out unsigned(2 downto 0));
 
end entity;

architecture structure of output_buffer is
	signal reg5, reg6, reg7, data              : unsigned(2 downto 0);
	signal reg0, reg1, reg2, reg3, reg4        : unsigned(2 downto 0);
	signal pop_reg, push_reg                   : unsigned(2 downto 0);
	signal full, empty                         : unsigned(0 downto 0);
		
begin

    process(pop_reg, empty)
    begin
	 if (empty = "0") then
        case pop_reg is
				when "000" => FIFO_OUT <= reg0;
				when "001" => FIFO_OUT <= reg1;
				when "010" => FIFO_OUT <= reg2;
				when "011" => FIFO_OUT <= reg3;
				when "100" => FIFO_OUT <= reg4;
				when "101" => FIFO_OUT <= reg5;
				when "110" => FIFO_OUT <= reg6;
				when "111" => FIFO_OUT <= reg7;
            when others      => null ;
        end case;
		end if;
    end process;

	
	process (CLK, RESET)
   begin
        if (reset = "1") then
            reg0 <= "000";
            reg1 <= "000";				
	         reg2 <= "000";			
            reg3 <= "000";
				reg4 <= "000";
            reg5 <= "000";				
	         reg6 <= "000";			
            reg7 <= "000";	
				
        elsif (CLK'event and CLK = "1") then 
			if (push_reg+1  /= pop_reg) then
				if (push_mem_in = "1" and push_reg_in = "1") then
				case push_reg+1 is
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
				case push_reg is
					when "000" => reg0 <= data;
					when "001" => reg1 <= data;
					when "010" => reg2 <= data;
					when "011" => reg3 <= data;
					when "100" => reg4 <= data;
					when "101" => reg5 <= data;
					when "110" => reg6 <= data;
					when "111" => reg7 <= data;
					when others      => null ;
					end case;					
				elsif (push_mem_in = "1" or push_reg_in = "1") then
				case push_reg is
					when "000" => reg0 <= data;
					when "001" => reg1 <= data;
					when "010" => reg2 <= data;
					when "011" => reg3 <= data;
					when "100" => reg4 <= data;
					when "101" => reg5 <= data;
					when "110" => reg6 <= data;
					when "111" => reg7 <= data;
					when others      => null ;
					end case;
					
				end if;
			end if;
	
			if (push_reg+1  /= pop_reg) then
				if (push_mem_in = "1" and push_reg_in = "1") then	
					push_reg <= push_reg + 2;
				elsif(push_mem_in = "1" or push_reg_in = "1") then
					push_reg <= push_reg + 1;
				end if;
			end if;
	
			if (empty = "0") then
				pop_reg <= pop_reg + 1;
			end if;	
				
  end if;
  end process;
	data  <= mem_in when push_mem_in = "1" else reg_in;
	empty <= "1" when pop_reg = push_reg else "0";
	full  <= "1" when pop_reg = push_reg + 1 else "0";
	
end structure;