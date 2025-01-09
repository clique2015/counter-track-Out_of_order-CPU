--------------------------------------------------------------------------------
-- PROJECTFPGA.COM
--------------------------------------------------------------------------------
-- NAME:    Modified Stack Ram - program_memory.vhd
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

entity data_memory is

  generic (
    addr_width : integer := 16;
    data_width : integer := 16 
  );

port(
  CLK, WE 						: in  unsigned(0 downto 0);
  addr, datain  				: in  unsigned(addr_width-1 downto 0);  
  dataout			 		 	: out unsigned(data_width-1 downto 0));
end entity;

architecture structure of data_memory is

type ram_type is array (2**addr_width-1 downto 0) of unsigned (data_width-1 downto 0);
signal ram_single_port : ram_type;
	
begin
	process (CLK)
   begin			
		if (CLK'event and CLK = "1") then 
		
        if WE = "1" then
			ram_single_port(to_integer(unsigned(addr))) <= datain;
			else
			dataout <= ram_single_port(to_integer(unsigned(addr)));
			end if;

		end if;
  end process;			
				
end structure;