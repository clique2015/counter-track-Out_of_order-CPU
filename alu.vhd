
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


entity alu is

port(
  regA, regB                             : in  unsigned(15 downto 0);
  OPERAND                                : in  unsigned(2 downto 0);
  GT, LT, EQ                             : out unsigned(0 downto 0);
  alu_out                                : out unsigned(15 downto 0));
 
end entity;
architecture structure of alu is
 signal check_sign : unsigned(15 downto 0);
 
 begin
 process(regA, regB, OPERAND)
 begin
  case OPERAND is
	when "000"   => alu_out <=  	regA + regB;
	when "001"   => alu_out <=  	shift_left(regA,	to_integer(regB(3 downto 0)));
	when "010"   => alu_out <=    check_sign;
	when "011"   => alu_out <= 	regA - regB;
	when "100"   => alu_out <= 	regA xor regB;
	when "101"	 => alu_out <=    shift_right(regA,	to_integer(regB(3 downto 0)));
	when "110"   => alu_out <=    regA or regB;
	when "111"	 => alu_out <= 	regA and regB;
	when others   => null ;
  end case;
 end process;
   
	GT <= "1" when regA > regB else "0";	 
	LT <= "1" when regA < regB else "0";		 
	EQ <= "1" when regA = regB else "0";
   check_sign <= x"0000" when regA < regB else x"0001" when regA > regB;
	
end structure;