
--------------------------------------------------------------------------------
-- PROJECTFPGA.COM
--------------------------------------------------------------------------------
-- NAME:    cache.vhd
--------------------------------------------------------------------------------
-- AUTHORS: Ezeuko Emmanuel <ezeuko.arinze@projectfpga.com>
--------------------------------------------------------------------------------
-- WEBSITE: https://projectfpga.com/iosoc
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- brainio
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


entity cache_control is

  generic (
	 no_of_ways     : integer := 4;
    ways_bit       : integer := 2;
    address_bits   : integer := 16; -- we used 5 offset bit, 3 set bit, 8 tag bits and 16 unused bits
	 cache_bits     : integer :=5; 
	 set_bits       : integer := 3;
	 tag_bits       : integer := 8;
	 block_offset : integer := 5
  );
  
port(
  clock, reset, enable  											 : in unsigned(0 downto 0);
  set_addr_16											 				 : in unsigned(15 downto 0);   
  miss, hit									  				 			 : out unsigned(0 downto 0);  
  lru_addr_16											 				 : out unsigned(15 downto 0);  
  set_addr_5, lru_addr_5											 : out unsigned(ways_bit + set_bits-1 downto 0));
 
end entity;

architecture structure of cache_control is
	signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7   				: unsigned(no_of_ways * tag_bits -1  downto 0);	
	signal tag_register	, new_tag												: unsigned(no_of_ways * tag_bits -1  downto 0);
	signal lru_register	,new_LRUvalue											: unsigned(no_of_ways * ways_bit-1 downto 0);
	signal regA, regB, regC, regD, regE, regF, regG, regH					: unsigned(no_of_ways * ways_bit-1 downto 0);
	signal dirt0, dirt1, dirt2, dirt3, dirt4, dirt5, dirt6, dirt7		: unsigned(no_of_ways-1 downto 0);
	signal dirt_sig, dirt_reg														: unsigned(no_of_ways-1 downto 0);	
	signal block_index, tag_index													: unsigned(address_bits-1 downto 0);
	signal tagA, tagB, tagC, tagD, tag, miss_tag    						: unsigned(tag_bits-1 downto 0);
	signal lru_position, hit_position, LRUd, LRUc, LRUb, LRUa			: unsigned(ways_bit-1 downto 0);	
	signal set_index   																: unsigned(set_bits-1 downto 0);
	signal way0, way1, way2, way3, dirtA, dirtB, dirtC, dirtD			: unsigned(0 downto 0);
	signal hit_sig, dirty_bit    													: unsigned(0 downto 0);


	
begin

----------------------------------------------	
-- store to register
-- store the tag bits
-- store the LRU value (we are using Least Recently Used(LRU) as the replacement policy)
----------------------------------------------	
process(reset, clock)
	begin
	  if (reset =  "1") then		  
			reg0    <= x"00000000";
			reg1	  <= x"00000000";
			reg2    <= x"00000000";
			reg3	  <= x"00000000";
			reg4    <= x"00000000";
			reg5	  <= x"00000000";
			reg6    <= x"00000000";
			reg7	  <= x"00000000";			
			
			regA    <= x"00";
			regB	  <= x"00";
			regC    <= x"00";
			regD	  <= x"00";
			regE    <= x"00";
			regF	  <= x"00";
			regG    <= x"00";
			regH	  <= x"00";
			
			dirt0   <= x"0";
			dirt1	  <= x"0";
			dirt2   <= x"0";
			dirt3	  <= x"0";
			dirt4   <= x"0";
			dirt5	  <= x"0";
			dirt6   <= x"0";
			dirt7	  <= x"0";
			
	  elsif (clock'event and clock =  "1") then 
			
			if (enable = "1") then	 
			  case set_index is
					when "000" => 
					reg0  <= new_tag;
					regA  <= new_LRUvalue;
					dirt0 <= dirt_sig;
					
					when "001" => 
					reg1  <= new_tag;
					regB  <= new_LRUvalue;
					dirt1 <= dirt_sig;
					
					when "010" => 
					reg2  <= new_tag;
					regC  <= new_LRUvalue;
					dirt2 <= dirt_sig;
					
					when "011" => 
					reg3  <= new_tag;
					regD  <= new_LRUvalue;
					dirt3 <= dirt_sig;
					
					when "100" => 
					reg4  <= new_tag;
					regE  <= new_LRUvalue;
					dirt4 <= dirt_sig;
					
					when "101" => 
					reg5  <= new_tag;
					regF  <= new_LRUvalue;
					dirt5 <= dirt_sig;
					
					when "110" => 
					reg6  <= new_tag;
					regG  <= new_LRUvalue;
					dirt6 <= dirt_sig;
					
					when "111" => 
					reg7  <= new_tag;
					regH  <= new_LRUvalue;
					dirt7 <= dirt_sig;
					
					when others      => null ;
			  end case; 
			end if;

			
		end if;
end process;			
----------------------------------------------	
--calculations
----------------------------------------------	

		 block_index <=    shift_right(set_addr_16,	block_offset);
		 tag   <=    shift_right(block_index,	set_bits);
		 set_index   <=    block_index(set_bits-1 downto 0);

		 
		  way0 <= "1" when tag_register(7 downto  0 ) = tag else "0";
		  way1 <= "1" when tag_register(15 downto 8 ) = tag else "0";
		  way2 <= "1" when tag_register(23 downto 16) = tag else "0";
		  way3 <= "1" when tag_register(31 downto 24) = tag else "0";
		  
		  hit_sig 	<= (way0 or way1 or way2 or way3) and dirty_bit ;
		  miss 		<= not hit_sig;
		  hit  		<= hit_sig;
								
        hit_position <= "00" when way0 = 1 else
								"01" when way1 = 1 else
								"10" when way2 = 1 else
								"11" when way3 = 1 else
								"00"; -- Default state when neither condition is met
								
        set_addr_5 		<= set_index & hit_position ;
								
        lru_position <= "00" when hit_position = lru_register(1 downto 0) else
								"01" when hit_position = lru_register(3 downto 2) else
								"10" when hit_position = lru_register(5 downto 4) else
								"11" when hit_position = lru_register(7 downto 6) else	
								"00"; -- Default state when neither condition is met
								
			dirtA <= "1" when lru_register(7 downto 6) = "00" else dirt_reg(0 downto 0);
			dirtB <= "1" when lru_register(7 downto 6) = "01" else dirt_reg(1 downto 1);
			dirtC <= "1" when lru_register(7 downto 6) = "10" else dirt_reg(2 downto 2);
			dirtD <= "1" when lru_register(7 downto 6) = "11" else dirt_reg(3 downto 3);
			
			dirt_sig <= dirtD & dirtC & dirtB & dirtA;

        dirty_bit <=    dirt_reg(0 downto 0) when lru_register(7 downto 6) = "00" else
								dirt_reg(1 downto 1) when lru_register(7 downto 6) = "01" else
								dirt_reg(2 downto 2) when lru_register(7 downto 6) = "10" else
								dirt_reg(3 downto 3) when lru_register(7 downto 6) = "11"; -- Default state when neither condition is met

			
			tagA <= tag when lru_register(7 downto 6) = "00" else tag_register(7 downto 0);
			tagB <= tag when lru_register(7 downto 6) = "01" else tag_register(15 downto 8);
			tagC <= tag when lru_register(7 downto 6) = "10" else tag_register(23 downto 16);
			tagD <= tag when lru_register(7 downto 6) = "11" else tag_register(31 downto 24);
			
			new_tag <= tagD & tagC & tagB & tagA;
			
			LRUa <= hit_position				   when lru_position = 0 else lru_register(1 downto 0);
			LRUb <= lru_register(3 downto 2) when lru_position < 1 else lru_register(1 downto 0);
			LRUc <= lru_register(5 downto 4) when lru_position < 2 else lru_register(3 downto 2);
			LRUd <= lru_register(7 downto 6) when lru_position < 3 else lru_register(5 downto 4);
			
			miss_tag <= 	tag_register(7 downto 0) 	when lru_register(7 downto 6) = "00" else
								tag_register(15 downto 8) 	when lru_register(7 downto 6) = "01" else
								tag_register(23 downto 16) when lru_register(7 downto 6) = "10" else
								tag_register(31 downto 24) when lru_register(7 downto 6) = "11"; -- Default state when neither condition is met
			
			new_LRUvalue 	<= LRUd & LRUc & LRUb & LRUa;
			lru_addr_5 		<= set_index & lru_register(7 downto 6);
			lru_addr_16 	<= miss_tag & set_index & "00000";
			
		process(set_index)
		begin
			 case set_index is
				  when "000" =>
						tag_register <= reg0;
						lru_register <= regA;
						dirt_reg     <= dirt0;
						
				  when "001" =>
						tag_register <= reg1;
						lru_register <= regB;
						dirt_reg     <= dirt1;
						
				  when "010" =>
						tag_register <= reg2;
						lru_register <= regC;
						dirt_reg     <= dirt2;
						
				  when "011" =>
						tag_register <= reg3;
						lru_register <= regD;
						dirt_reg     <= dirt3;
						
				  when "100" =>
						tag_register <= reg4;
						lru_register <= regE;
						dirt_reg     <= dirt4;
						
				  when "101" =>
						tag_register <= reg5;
						lru_register <= regF;
						dirt_reg     <= dirt5;
						
				  when "110" =>
						tag_register <= reg6;
						lru_register <= regG;
						dirt_reg     <= dirt6;
						
				  when "111" =>
						tag_register <= reg7;
						lru_register <= regH;
						dirt_reg     <= dirt7;
				  when others =>
						null;
			 end case;
		end process;


				
----------------------------------------------

end structure;