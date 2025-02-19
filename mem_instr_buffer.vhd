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


library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity mem_instr_buffer is

port(
  CLK, RESET, PUSH_FIFO, POP_FIFO        : in  unsigned(0 downto 0);
  FIFO_IN                                : in  unsigned(22 downto 0);
  FIFO_FULL, FIFO_EMPTY                  : out unsigned(0 downto 0);
  FIFO_OUT                               : out unsigned(22 downto 0));
 
end entity;

architecture structure of mem_instr_buffer is
	signal reg5, reg6, reg7                    : unsigned(22 downto 0);
	signal reg0, reg1, reg2, reg3, reg4        : unsigned(22 downto 0);
	signal regA, regB                          : unsigned(2 downto 0);
	signal full, empty                         : unsigned(0 downto 0);
		
begin

    process(regA)
    begin
        case regA is
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
    end process;

	
	process (CLK, RESET)
   begin
        if (reset = "1") then
            reg0 <= (others => '0');
            reg1 <= (others => '0');				
	         reg2 <= (others => '0');			
            reg3 <= (others => '0');
				reg4 <= (others => '0');
            reg5 <= (others => '0');				
	         reg6 <= (others => '0');			
            reg7 <= (others => '0');	
				
        elsif (CLK'event and CLK = "1") then 
			if (PUSH_FIFO = "1") then
				case regB is
					when "000" => reg0 <= FIFO_IN;
					when "001" => reg1 <= FIFO_IN;
					when "010" => reg2 <= FIFO_IN;
					when "011" => reg3 <= FIFO_IN;
					when "100" => reg4 <= FIFO_IN;
					when "101" => reg5 <= FIFO_IN;
					when "110" => reg6 <= FIFO_IN;
					when "111" => reg7 <= FIFO_IN;
					when others      => null ;
        end case;
	end if;
	
			if (PUSH_FIFO = "1") then
				if (full = "0") then	
				regB <= regB + 1;
			end if;
			end if;
	
			if (POP_FIFO = "1") then
				if (empty = "0") then	
				regA <= regA + 1;
			end if;
			end if;	
				
  end if;
  end process;
	 
	empty <= "1" when regA = regB else "0";
	full  <= "1" when regA = regB + 1 else "0";
	
	FIFO_EMPTY <=	empty;
	FIFO_FULL  <=	full;
	
end structure;