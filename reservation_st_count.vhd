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

entity instr_counter is

port(
  CLK, RESET, enable 		 : in  unsigned(0 downto 0);  
  setA1, setA2, setA3, setB1: in  unsigned(0 downto 0);  
  setB2, setB3, setC1, setC2: in  unsigned(0 downto 0);
  setC3, setD1, setD2, setD3: in  unsigned(0 downto 0);  
  setE1, setE2, setE3, setF1: in  unsigned(0 downto 0);  
  setF2, setF3, setG1, setG2: in  unsigned(0 downto 0);  
  setG3							 : in  unsigned(0 downto 0);   
  addr_in					    : in  unsigned(2 downto 0);
  sum                   	 : in  unsigned(3 downto 0); 
  reg_stat_bit              : in  unsigned(7 downto 0);
  reg_out              		 : out unsigned(2 downto 0));
 
end entity;

architecture structure of instr_counter is
	signal reg5, reg6, reg7, data       : unsigned(3 downto 0);
	signal reg0, reg1, reg2, reg3, reg4 : unsigned(3 downto 0);
	signal m1, m2, m3, m4, m5, m6, m7	: unsigned(1 downto 0);
		
begin

	m1 <= ("0" & setA1) + ("0" & setA2) + ("0" & setA3);	
	m2 <= ("0" & setB1) + ("0" & setB2) + ("0" & setB3);	
	m3 <= ("0" & setC1) + ("0" & setC2) + ("0" & setC3);	
	m4 <= ("0" & setD1) + ("0" & setD2) + ("0" & setD3);	
	m5 <= ("0" & setE1) + ("0" & setE2) + ("0" & setE3);	
	m6 <= ("0" & setF1) + ("0" & setF2) + ("0" & setF3);	
	m7 <= ("0" & setG1) + ("0" & setG2) + ("0" & setG3);

process(reg_stat_bit)
begin
       if reg_stat_bit(7 downto 7) = "1" and reg7 = "0000" then reg_out <= "111";
    elsif reg_stat_bit(6 downto 6) = "1" and reg6 = "0000" then reg_out <= "110";
    elsif reg_stat_bit(5 downto 5) = "1" and reg5 = "0000" then reg_out <= "101";
    elsif reg_stat_bit(4 downto 4) = "1" and reg4 = "0000" then reg_out <= "100";
    elsif reg_stat_bit(3 downto 3) = "1" and reg3 = "0000" then reg_out <= "011";
    elsif reg_stat_bit(2 downto 2) = "1" and reg2 = "0000" then reg_out <= "010";
    elsif reg_stat_bit(1 downto 1) = "1" and reg1 = "0000" then reg_out <= "001";
    else
        reg_out <= (others => '0'); -- Default case
    end if;
end process;

	
	process (CLK, RESET)
   begin
        if (reset = "1") then
            reg0 <= "0000";
            reg1 <= "0000";				
	         reg2 <= "0000";			
            reg3 <= "0000";
				reg4 <= "0000";
            reg5 <= "0000";				
	         reg6 <= "0000";			
            reg7 <= "0000";	
				
        elsif (CLK'event and CLK = "1") then 
			if (enable = "1") then
				case addr_in is
					when "000" => reg0 <= sum;
					when "001" => reg1 <= sum;
					when "010" => reg2 <= sum;
					when "011" => reg3 <= sum;
					when "100" => reg4 <= sum;
					when "101" => reg5 <= sum;
					when "110" => reg6 <= sum;
					when "111" => reg7 <= sum;
					when others      => null ;
					end case;
				elsif (reg_stat_bit > "00000001") then 
            if reg_stat_bit(1 downto 1) = "1" then
                reg1 <= reg1 - ("00" & m1);
            end if;
            if reg_stat_bit(2 downto 2) = "1" then
                reg2 <= reg2 - ("00" & m2);
            end if;
            if reg_stat_bit(3 downto 3) = "1" then
                reg3 <= reg3 - ("00" & m3);
            end if;
            if reg_stat_bit(4 downto 4) = "1" then
                reg4 <= reg4 - ("00" & m4);
            end if;
            if reg_stat_bit(5 downto 5) = "1" then
                reg5 <= reg5 - ("00" & m5);
            end if;
            if reg_stat_bit(6 downto 6) = "1" then
                reg6 <= reg6 - ("00" & m6);
            end if;
            if reg_stat_bit(7 downto 7) = "1" then
                reg7 <= reg7 - ("00" & m7);
            end if;
		end if;
				
  end if;
  end process;
	
end structure;













