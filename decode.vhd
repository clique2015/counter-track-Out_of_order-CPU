--------------------------------------------------------------------------------
-- PROJECTFPGA.COM
--------------------------------------------------------------------------------
-- NAME:    decode.vhd
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


entity decode is

port(
  instruction																				: in  unsigned(31 downto 0);  
  imm_11_0	 																				: out unsigned(11 downto 0); 
  opcode, funct7									    									: out unsigned(6 downto 0);
  rd, rs1, rs2				 																: out unsigned(4 downto 0);   
  funct3												 										: out unsigned(2 downto 0); 
  unset,r_type, i_type, s_type, b_type, j_type  								: out unsigned(0 downto 0));
  end entity;

architecture structure of decode is
	signal r_type_sig, i_type_sig, s_type_sig, b_type_sig, j_type_sig, rs2_sig, rd_sig: unsigned(0 downto 0);
	signal funct3_sig : unsigned(2 downto 0);
	
begin
-------------------------------------------------------------
-- decoder
------------------------------------------------------------- 
  unset        <= b_type_sig or j_type_sig;
  rs2_sig      <= b_type_sig or r_type_sig or (s_type_sig and funct3_sig(0 downto 0));
  rd_sig			<= j_type_sig or r_type_sig or i_type_sig or (s_type_sig and not funct3_sig(0 downto 0)); 
  
  imm_11_0		<= instruction(11 downto 0);    
  opcode			<= instruction(6  downto 0);  
  funct7			<= instruction(31 downto 25);  	    												 		
  rd				<= instruction(11 downto 7)  when rd_sig  = "1" else "00000";
  rs1				<= instruction(19 downto 15);
  rs2				<= instruction(24 downto 20) when rs2_sig = "1" else "00000";
  funct3_sig	<= instruction(14 downto 12);
  
-------------------------------------------------------------
-- opcode 
-------------------------------------------------------------

	r_type_sig     <= "1" when instruction(6 downto 0) = "0110011" else "0";		
	i_type_sig     <= "1" when instruction(6 downto 0) = "0010011" else "0";		
	s_type_sig     <= "1" when instruction(6 downto 0) = "0100011" else "0";
	b_type_sig     <= "1" when instruction(6 downto 0) = "1100011" else "0";			
	j_type_sig     <= "1" when instruction(6 downto 0) = "1101111" else "0";		

	r_type     <= r_type_sig;		
	i_type     <= i_type_sig;		
	s_type     <= s_type_sig;
	b_type     <= b_type_sig;			
	j_type     <= j_type_sig;	
	
	funct3     <= funct3_sig;	
end structure;
--------------------------------------------------------------