
--------------------------------------------------------------------------------
-- PROJECTFPGA.COM
--------------------------------------------------------------------------------
-- NAME:    ALU - Arithmetic and Logic Unit- ALU.vhd
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


entity stat_reg is

port(
  clock, reset, read_miss  					: in  unsigned(0 downto 0);
  read_hit, write_miss, set, unset  		: in  unsigned(0 downto 0);
  addr_used, addr_unused                	: in  unsigned(2 downto 0);
  rm_delay, wm_delay, rh_delay, pause     : out unsigned(0 downto 0);
  free_addr                               : out unsigned(2 downto 0);
  stat_reg                                : out unsigned(7 downto 0));
	
end entity;
architecture structure of stat_reg is
 signal rm_delay_sig, rh_delay_sig, wm_delay_sig, pause_sig	: unsigned(0  downto 0);
 signal next_used_sig, next_used_sig1								: unsigned(7  downto 0);
 signal instr_buffer_stat_reg, rem_addr, rem_addr1 			: unsigned(7  downto 0);
 signal addr_used_sig, new_stat										: unsigned(15 downto 0);
 
 begin

	rm_delay 					<= rm_delay_sig;
	rh_delay 					<= rh_delay_sig;
	wm_delay 					<= wm_delay_sig;
	pause  	 					<= pause_sig;
	
 process(reset, clock)
	begin
	  if (reset =  "1") then		  
			rm_delay_sig    			<= "0";
			rh_delay_sig    			<= "0";
			wm_delay_sig    			<= "0";
			pause_sig		   		<= "0";
			instr_buffer_stat_reg  	<= x"00";
			
	  elsif (clock'event and clock =  "1") then 
	  
			rm_delay_sig 					<= read_miss  and rm_delay_sig;
			rh_delay_sig 					<= read_hit   and rh_delay_sig;
			wm_delay_sig 					<= write_miss and wm_delay_sig;
			
			if(set = "1") then
			pause_sig <= "1";
			elsif(unset = "1") then
			pause_sig <= "0";
			end if;
			
			instr_buffer_stat_reg 	<= next_used_sig1;
			
		end if;
end process;	

  free_addr <= 		"001" when instr_buffer_stat_reg(1 downto 1) = "000" else
                     "010" when instr_buffer_stat_reg(2 downto 2) = "000" else
                     "011" when instr_buffer_stat_reg(3 downto 3) = "000" else
                     "100" when instr_buffer_stat_reg(4 downto 4) = "000" else
                     "101" when instr_buffer_stat_reg(5 downto 5) = "000" else
                     "110" when instr_buffer_stat_reg(6 downto 6) = "000" else
                     "111" when instr_buffer_stat_reg(7 downto 7) = "000" else
                     "000";
							
							
 
 rem_addr 				<= 	shift_right(instr_buffer_stat_reg ,  to_integer("00000" & addr_used));
 rem_addr1 				<= 	shift_right(next_used_sig ,  			 to_integer("00000" & addr_unused));
 
 addr_used_sig  		<=    rem_addr(7 downto 1)  & "1"  & shift_left(instr_buffer_stat_reg , to_integer("1000" - ("0" & addr_used)));
 
next_used_sig			<=    shift_left(addr_used_sig , to_integer("0000000000000" & addr_unused))(15 downto 8);


	new_stat 			<=    rem_addr1(7 downto 1) & "0"  &  shift_left(next_used_sig , 			to_integer("1000" - ("0" & addr_used)));

next_used_sig1			<=		shift_left(new_stat , 		 to_integer("0000000000000" & addr_unused))(15 downto 8);
								
	
	stat_reg    <= instr_buffer_stat_reg;
end structure;