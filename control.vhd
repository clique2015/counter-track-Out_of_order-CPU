--------------------------------------------------------------------------------
-- PROJECTFPGA.COM
--------------------------------------------------------------------------------
-- NAME:    Last-In-First-out (stack) LIFO.vhd
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

entity control is

port(
  clk, reset, mem_fifo_full, eq, gt, lt, man_sel, hit, mem_rw	: in  unsigned(0  downto 0);
  mem_fifo_empty, miss, pause, wm_delay, rm_delay, rh_delay		: in  unsigned(0  downto 0);
  r_type, i_type, s_type, b_type, j_type								: in  unsigned(0  downto 0);
  funct3, mem_fifo_set_addr              								: in  unsigned(2  downto 0);    
  rd, rs1, rs2, lru_addr_5, cache_addr_5       						: in  unsigned(4  downto 0); 
  
  opcode, funct7, instr_stat_reg               						: in  unsigned(6  downto 0); 
  cache_dataout, regC_data, lru_addr_16, alu_out, regA 			: in  unsigned(15 downto 0); 
  regB, manual_pc, memory_out, current_pc , cache_addr_16		: in  unsigned(15 downto 0);   
  imm_11_0 																		: in  unsigned(11 downto 0);  
  
  mem_fifo_push, cache_write, cache_read								: out unsigned(0  downto 0);
  reg_en, instruction_fetch, mreg_en, mem_en	   					: out unsigned(0  downto 0); 
  
  reg_sel, regA_sel, regB_sel, aluop, mreg_sel    					: out unsigned(2  downto 0);
  rs1_out, rs2_out, rd_out        										: out unsigned(2  downto 0);  
  cache_addr																	: out unsigned(4  downto 0);  
  register_data, cache_data, memory_addr, memory_data			   : out unsigned(15 downto 0);
  aluA, aluB, pc_out, fifo_data   										: out unsigned(15 downto 0);
  mem_fifo_data     															: out unsigned(22 downto 0));
  
end entity;

architecture structure of control is
	signal push_reg_fifo_sig, fetch_instr, take_branch 			: unsigned(0  downto 0);
	signal read_hit, write_hit, read_miss, cache_write_sig	   : unsigned(0  downto 0);
	signal read_miss_1, read_miss_2, write_miss_1, write_miss_2	: unsigned(0  downto 0); 
	signal write_miss, reg_write_free									: unsigned(0  downto 0);
	signal rorw 																: unsigned(2  downto 0);
	signal reg5, reg6, reg7 , pc_reg           						: unsigned(15 downto 0);
	signal reg0, reg1, reg2, reg3, reg4,pc     						: unsigned(15 downto 0);			

begin

-------------------------------------------------------------
-- register operation
-------------------------------------------------------------
  
--  write back to the register
	 reg_en 	 					<= r_type or i_type or j_type;
	 
--  stores rs1, rs2 and rd to the buffer, used for Out-of-Order feedback
	 push_reg_fifo_sig 		<= r_type or i_type or j_type or b_type;
	 
--  RS1, RS2, RD Signal are copied into memory buffer for memory operations and their output set to zero 
    rs1_out 					<= rs1(2  downto 0) when push_reg_fifo_sig = "1" else "000";    
	 rs2_out 					<= rs2(2  downto 0) when push_reg_fifo_sig = "1" else "000";    
	 rd_out 					   <= rd(2   downto 0) when push_reg_fifo_sig = "1" else "000";
	 regA_sel					<= rs1(2  downto 0);
	 regB_sel					<= rs2(2  downto 0) when (r_type or b_type) = "1" else "000";
	 reg_sel 					<= rd(2   downto 0) when (r_type or i_type or j_type) = "1" else "000";
	 register_data				<= alu_out when (r_type or i_type) = "1" else pc_reg + "1" when j_type = "1" else x"0000";
	 
-------------------------------------------------------------
-- alu operation
-------------------------------------------------------------	
--  set subtraction to alu operation 3. 
	 aluop						<= "011" when (funct3 = "000" and funct7 = x"20") else funct3;
	 aluA							<= regA  when (r_type or b_type or i_type) <= "1" else x"0000";
	 aluB							<= regB  when (r_type or b_type) <= "1" else (x"0" & imm_11_0) when i_type <= "1" else x"0000";

-------------------------------------------------------------
-- memory instruction
-------------------------------------------------------------
    
--  cache hit/miss operation
	 read_hit           <= "1" when mem_fifo_empty = "0" and hit = "1" and mem_rw = "0" else "0";
	 write_hit          <= "1" when mem_fifo_empty = "0" and hit = "1" and mem_rw = "1" else "0";	 
	 read_miss          <= "1" when mem_fifo_empty = "0" and hit = "0" and mem_rw = "0" else "0";	 
	 write_miss         <= "1" when mem_fifo_empty = "0" and hit = "0" and mem_rw = "1" else "0";

	 read_miss_1 		  <= "1" when read_miss  = "1" and rm_delay = "0" else "0";
	 read_miss_2        <= "1" when read_miss  = "1" and rm_delay = "1" else "0";	 
	 write_miss_1       <= "1" when write_miss = "1" and wm_delay = "0" else "0";
	 write_miss_2       <= "1" when write_miss = "1" and wm_delay = "1" else "0";
	 
--  memory operation
	 mem_en 				  <= "1" when write_miss_2 = "1" or read_miss_2 = "1" else "0";
	 memory_data		  <= cache_dataout when (read_miss_2 = "1" or write_miss_2 = "1") else x"0000";
	 memory_addr		  <= lru_addr_16 when write_miss_2 = "1" or read_miss_2 = "1" else cache_addr_16 when read_miss_1 = "1" else x"0000";
	 
--	 cache operation	 
	 cache_data			  <= regC_data when (write_hit = "1" or write_miss_2 = "1") else memory_out when read_miss_2 = "1" else x"0000";
	 cache_write_sig    <= "1" when write_hit = "1" or read_miss_2 = "1" or write_miss_2 = "1"else "0";
	 cache_read			  <= "1" when cache_write_sig = "1" and rh_delay = "1" else "0"; 
    cache_addr         <= cache_addr_5 when read_hit = "1" or write_hit = "1" or read_miss_2 = "1" or write_miss_2 = "1" 
									else lru_addr_5 when write_miss_1 = "1" or read_miss_1 = "1" else "00000";
	 cache_write        <= cache_write_sig;						
--  fifo operation									
	 mreg_en            <= rh_delay or read_miss_2;
	 mreg_sel			  <= mem_fifo_set_addr when (rh_delay = "1" or (read_miss = "1" and rm_delay = "1")) else "000";
	 fifo_data  		  <= cache_dataout when rh_delay = "1" else memory_out when read_miss_2 = "1" else x"0000";
	 mem_fifo_push      <= not mem_fifo_full and s_type;
	 rorw					  <= rs2(2 downto 0) when funct3(0 downto 0) = "1" else rd(2 downto 0);	 
	 mem_fifo_data      <= rs1(2 downto 0) & funct3(0 downto 0) & rorw & ("000000000" & funct7) + regA;
	 
	 
-------------------------------------------------------------
-- program counter
-------------------------------------------------------------
	fetch_instr 			<= "1" when instr_stat_reg < x"ff" else "0";
	instruction_fetch 	<= fetch_instr;
	process(b_type)
	begin			
        if (b_type = "1") then
			case funct3 is
				when "000" => take_branch <= eq;
				when "001" => take_branch <= not eq;
				when "010" => take_branch <= gt;
				when "011" => take_branch <= not gt;
				when "100" => take_branch <= lt;
				when "101" => take_branch <= not lt;
				when "110" => take_branch <= "0";
				when "111" => take_branch <= "0";				
				when others      => null ;
			end case;
		  end if;

		if (take_branch = "1") then
			pc      <= current_pc + ("000000000" & funct7);

			elsif(j_type = "1") then
			if(funct3 = "001") then
			pc 	  <= regA + current_pc;
			else
			pc		  <= regA + (b"0000" & imm_11_0);	
			end if;

			elsif(man_sel = "1") then
			pc      <= manual_pc;

			elsif(pause = "1") then
			pc      <= pc_reg;
			
			elsif(fetch_instr = "1") then
			pc      <= pc_reg + 1;
			
			else
			pc      <= pc_reg;
		end if;

		if (reset = "1") then
			pc_reg <= x"0000";

			elsif (CLK'event and CLK = "1") then 
			pc_reg <= pc;		
		end if;
	end process;
	
	pc_out <= pc_reg;
	
end structure;