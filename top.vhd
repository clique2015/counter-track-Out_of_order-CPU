
--------------------------------------------------------------------------------
-- PROJECTFPGA.COM
--------------------------------------------------------------------------------
-- NAME:    register.vhd
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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity brainio is
    Port (
        clock, man_sel , reset  											: in  unsigned(0  downto 0);
		  write_addr, manual_pc 											: in  unsigned(15 downto 0);
		  data_in 																: in  unsigned(31 downto 0);
		  reg_0, reg_1, reg_2, reg_3, reg_4, reg_5, reg_6, reg_7 : out unsigned(15 downto 0);
        pc_out 																: out unsigned(15 downto 0)
    );
end entity;

architecture Structural of brainio is


    signal enable, unset, rh_delay, rm_delay, wm_delay, pause	: unsigned(0 downto 0); 
	 signal read_miss, read_hit, write_miss, set,memory_enable	: unsigned(0 downto 0);
	 signal setE3, setF3, setG3, setA3, setB3, setC3, setD3		: unsigned(0 downto 0);
	 signal setE1, setF1, setG1, setA1, setB1, setC1, setD1		: unsigned(0 downto 0);
	 signal setE2, setF2, setG2, setA2, setB2, setC2, setD2		: unsigned(0 downto 0);	 
	 signal GT, LT, EQ, cache_write, hit, miss, cache_read		: unsigned(0 downto 0);
	 signal mem_fifo_push, mem_fifo_full, mem_fifo_empty, reg_en: unsigned(0 downto 0);
	 signal mreg_en, push_reg_fifo										: unsigned(0 downto 0);	 	 
	 signal addr_in, addr_out, funct3, operand						: unsigned(2 downto 0);
	 signal rs1_out, rd_out, rs2_out, mem_sig							: unsigned(2 downto 0);
	 signal nmem_sig, mreg_sel, reg_sel, regA_sel, regB_sel		: unsigned(2 downto 0);
	 signal rd, rs1, rs2, rd_count, rs1_count, rs2_count			: unsigned(2 downto 0);
	 signal rs2_check, rd_check,  rs1_check							: unsigned(2 downto 0);	 
	 signal rs1_main, rs2_main, rd_main									: unsigned(4 downto 0);
	 signal cache_addr_out, cache_set_addr_5, lru_addr_5			: unsigned(4 downto 0);
	 signal opcode, funct7, reg_stat_bit								: unsigned(6 downto 0);
	 signal imm_11_0															: unsigned(11 downto 0);
	 signal pc_in, pc_out_sig, alu_out, regA, regB, regC_data 	: unsigned(15 downto 0);
	 signal cache_data_out, cache_set_addr_16, register_data 	: unsigned(15 downto 0);
	 signal lru_address_16, m_fifo_data, cache_data, aluA, aluB : unsigned(15 downto 0);
	 signal memory_out, memory_data, memory_address					: unsigned(15 downto 0);
	 signal instr_in, instr_out											: unsigned(31 downto 0); 
	 signal fifo_out, mem_fifo_data										: unsigned(22 downto 0);
	 
begin
  
  pc_out 				<=  pc_out_sig;
  mem_sig 				<= fifo_out(18 downto 16) when fifo_out(19 downto 19) = "0" else "000";
  nmem_sig 				<= fifo_out(18 downto 16) when fifo_out(19 downto 19) = "1" else "000";  

  U22: entity work.control
  Port map ( 
  clk						=> 	clock,
  reset					=> 	reset,
  r_type					=>    r_type,
  i_type					=>    i_type,
  s_type					=>    s_type,
  b_type					=>    b_type,
  j_type					=>    j_type,
  mem_fifo_full		=> 	mem_fifo_full,
  eq						=> 	EQ,
  gt						=> 	GT,
  lt						=> 	LT,
  man_sel 				=> 	man_sel,
  mem_fifo_empty		=> 	mem_fifo_empty,
  hit						=> 	hit,
  miss					=> 	miss,
  pause  				=> 	pause,
  mem_rw					=> 	fifo_out(19 downto 19),
  wm_delay				=> 	wm_delay,
  rm_delay				=> 	rm_delay,
  rh_delay				=> 	rh_delay,
  funct3					=> 	funct3,
  mem_fifo_set_addr  => 	fifo_out(18 downto 16),   
  rd						=> 	rd_main,
  rs1						=> 	rs1_main,
  rs2						=> 	rs2_main,
  lru_addr_5			=> 	lru_addr_5,
  cache_addr_5       => 	cache_set_addr_5, 
  opcode					=> 	opcode,
  funct7					=> 	funct7,
  instr_stat_reg     => 	reg_stat_bit, 
  cache_dataout		=> 	cache_data_out,
  regC_data				=> 	regC_data,
  lru_addr_16			=> 	lru_address_16,
  alu_out				=> 	alu_out,
  regA 					=> 	regA,
  regB					=> 	regB,
  manual_pc				=> 	manual_pc,
  memory_out			=> 	memory_out,
  current_pc			=> 	pc_out_sig,
  cache_addr_16		=> 	cache_set_addr_16,  
  imm_11_0 				=> 	imm_11_0,  
  mem_fifo_push		=> 	mem_fifo_push,
  cache_write			=> 	cache_write,
  cache_read			=> 	cache_read,
  reg_en					=> 	reg_en,
  instruction_fetch	=> 	enable,
  mreg_en				=> 	mreg_en,
  mem_en	   			=> 	memory_enable, 
  reg_sel				=> 	reg_sel,
  regA_sel				=> 	regA_sel,
  regB_sel				=> 	regB_sel,
  aluop					=> 	operand,
  mreg_sel    			=> 	mreg_sel,
  rs1_out				=> 	rs1_out,
  rs2_out				=> 	rs2_out,
  rd_out        		=> 	rd_out,  
  cache_addr			=> 	cache_addr_out, 
  register_data		=> 	register_data,
  cache_data			=> 	cache_data,
  memory_addr			=> 	memory_address,
  memory_data			=> 	memory_data,
  aluA					=> 	aluA,
  aluB					=> 	aluB,
  pc_out					=> 	pc_in,
  fifo_data   			=> 	m_fifo_data,
  mem_fifo_data     	=> 	mem_fifo_data
  );
  
  U21: entity work.registers
  Port map (   
  clock					=> 	clock,
  reset					=> 	reset,
  enable					=> 	reg_en,
  m_enable  			=> 	mreg_en,
  reg_sel				=> 	reg_sel,
  regA_sel				=> 	regA_sel,
  regB_sel				=> 	regB_sel,
  regC_sel				=> 	fifo_out(18 downto 16),
  mem_sel          	=> 	mreg_sel, 
  reg_in					=> 	register_data,
  mem_in             => 	m_fifo_data,
  reg_0					=> 	reg_0,
  reg_1					=> 	reg_1,
  reg_2					=> 	reg_2,
  reg_3					=> 	reg_3,
  reg_4					=> 	reg_4,
  reg_5					=> 	reg_5,
  reg_6					=> 	reg_6,
  reg_7					=> 	reg_7,
  regA_out				=> 	regA,
  regB_out				=> 	regB,
  regC_out				=> 	regC_data
  );
  
  U20: entity work.output_buffer
  Port map ( 
  CLK						=> 	clock,
  RESET					=> 	reset,
  push_mem_in			=> 	cache_read,
  push_reg_in   		=> 	push_reg_fifo,
  mem_in					=> 	mem_sig,
  reg_in             => 	rd_out,
  FIFO_OUT           => 	rd_check
  );
  
  U19: entity work.output_buffer
  Port map ( 
  CLK						=> 	clock,
  RESET					=> 	reset,
  push_mem_in			=> 	cache_read,
  push_reg_in   		=> 	push_reg_fifo,
  mem_in					=> 	nmem_sig,
  reg_in             => 	rs2_out,
  FIFO_OUT           => 	rs2_check
  );
  
  U18: entity work.output_buffer
  Port map ( 
  CLK						=> 	clock,
  RESET					=> 	reset,
  push_mem_in			=> 	cache_read,
  push_reg_in   		=> 	push_reg_fifo,
  mem_in					=> 	fifo_out(22 downto 20),
  reg_in             => 	rs1_out,
  FIFO_OUT           => 	rs1_check
  );
  
  U17: entity work.mem_instr_buffer
  Port map ( 
  CLK						=> 	clock,
  RESET					=> 	reset,
  PUSH_FIFO				=> 	mem_fifo_push,
  POP_FIFO        	=> 	cache_read,
  FIFO_IN            => 	mem_fifo_data,
  FIFO_FULL				=> 	mem_fifo_full,
  FIFO_EMPTY         => 	mem_fifo_empty,
  FIFO_OUT 				=> 	fifo_out
  );
  
  U16: entity work.data_memory
  Port map (   
   CLK					=> 	clock,
	WE 					=> 	memory_enable,
  addr					=> 	memory_address,
  datain  				=> 	memory_data, 
  dataout				=> 	memory_out
  );
  
  U15: entity work.cache
  Port map ( 
  CLK						=> 	clock,
  WE 						=> 	cache_write,
  addr  					=> 	cache_addr_out,  
  datain  				=> 	cache_data,    
  dataout			 	=> 	cache_data_out
	);
	
  U14: entity work.cache_control
  Port map (   
  clock					=> 	clock,
  reset					=> 	reset,
  enable  				=> 	cache_read,
  set_addr_16			=> 	cache_set_addr_16,   
  miss					=> 	miss,
  hit						=> 	hit, 
  lru_addr_16			=> 	lru_address_16,  
  set_addr_5			=> 	cache_set_addr_5,
  lru_addr_5			=> 	lru_addr_5
  );
  
  U13: entity work.alu
  Port map (  
  regA					=> 	aluA,
  regB               => 	aluB,
  OPERAND            => 	operand,
  GT						=> 	GT,
  LT						=> 	LT,
  EQ                 => 	EQ,
  alu_out 				=> 	alu_out
  );
  
  U12: entity work.stat_reg
  Port map ( 
  clock 					=> 	clock,
  reset					=> 	reset,
  read_miss 			=> 	read_miss,
  read_hit				=> 	read_hit,
  write_miss			=> 	write_miss,
  set						=> 	set,
  unset  				=> 	unset,
  addr_used				=> 	addr_in,
  addr_unused        => 	addr_out,
  rm_delay				=> 	rm_delay,
  wm_delay				=> 	wm_delay,
  rh_delay				=> 	rh_delay,
  pause     			=> 	pause,
  free_addr          => 	addr_in,
  stat_reg(7 downto 1) => 	reg_stat_bit
  );
  
  U11: entity work.instr_counter
  Port map ( 
  CLK						=> 	clock,
  RESET					=> 	reset,
  enable 				=> 	enable, 
  setA1					=> 	setA1,
  setA2					=> 	setA2,
  setA3					=> 	setA3,
  setB1					=> 	setB1,  
  setB2					=> 	setB2,
  setB3					=> 	setB3,
  setC1					=> 	setC1,
  setC2					=> 	setC2,
  setC3					=> 	setC3,
  setD1					=> 	setD1,
  setD2					=> 	setD2,
  setD3					=> 	setD3,  
  setE1					=> 	setE1,
  setE2					=> 	setE2,
  setE3					=> 	setE3,
  setF1					=> 	setF1, 
  setF2					=> 	setF2,
  setF3					=> 	setF3,
  setG1					=> 	setG1,
  setG2					=> 	setG2,  
  setG3					=> 	setG3,   
  addr_in				=> 	addr_in,
  sum                => 	("0" & rs1_count) + ("0" & rs2_count) + ("0" & rd_count),
  reg_stat_bit(7 downto 1)       => 	reg_stat_bit,
  reg_out            => 	addr_out 
  );
  
  U10: entity work.rd_compare
  Port map (  
  clock					=> 	clock,
  reset					=> 	reset,
  enable					=> 	enable,
  rd						=> 	rd,
  rs1_check				=> 	rs1_check,
  rs2_check				=> 	rs2_check,
  addr  					=> 	addr_in,  
  setE					=> 	setE3,
  setF					=> 	setF3,
  setG         		=> 	setG3,
  setA					=> 	setA3,
  setB					=> 	setB3,
  setc					=> 	setC3,
  setD					=> 	setD3
  );

  U9: entity work.rs_compare
  Port map (   
  clock					=> 	clock,
  reset					=> 	reset,
  enable					=> 	enable,
  addr					=> 	addr_in,
  check_reg				=> 	rd_check,
  reg_in  				=> 	rs1,  
  setE					=> 	setE1,
  setF					=> 	setF1,
  setG         		=> 	setG1,
  setA					=> 	setA1,
  setB					=> 	setB1,
  setc					=> 	setC1,
  setD					=> 	setD1
  );
 
  U8: entity work.rs_compare
  Port map (   
  clock					=> 	clock,
  reset					=> 	reset,
  enable					=> 	enable,
  addr					=> 	addr_in,
  check_reg				=> 	rd_check,
  reg_in  				=> 	rs2,  
  setE					=> 	setE2,
  setF					=> 	setF2,
  setG         		=> 	setG2,
  setA					=> 	setA2,
  setB					=> 	setB2,
  setc					=> 	setC2,
  setD					=> 	setD2
  );
  
  U7: entity work.read_count
  Port map (  
  CLK						=> 	clock,
  RESET					=> 	reset,
  enable 		 		=> 	enable,
  rs1_check				=> 	rs1_check,
  rs2_check				=> 	rs2_check,
  rs2						=> 	rs2,
  rs1						=> 	rs1,
  rd				 		=> 	rd,
  rd_count           => 	rd_count
  );

  U6: entity work.write_count
  Port map (   
  CLK						=> 	clock,
  RESET					=> 	reset,
  enable 		 		=> 	enable,
  rd_check				=> 	rd_check,
  rd						=> 	rd,
  rs2						=> 	rs2,
  rs1	 					=> 	rs1,
  rs1_count				=> 	rs1_count,
  rs2_count				=> 	rs2_count
  );
  
  U5: entity work.decode
  Port map (
  instruction			=> 	instr_in,  
  rd(2 downto 0)		=> 	rd,
  rs1(2 downto 0)		=> 	rs1,
  rs2(2 downto 0)		=> 	rs2,
  unset     			=> 	set  
  );
  
  U4: entity work.decode
  Port map (
  instruction			=> 	instr_out,  
  imm_11_0	 			=> 	imm_11_0, 
  opcode					=> 	opcode,
  r_type					=>    r_type,
  i_type					=>    i_type,
  s_type					=>    s_type,
  b_type					=>    b_type,
  j_type					=>    j_type,
  funct7					=> 	funct7,
  rd						=> 	rd_main,
  rs1						=> 	rs1_main,
  rs2				 		=> 	rs2_main,   
  funct3					=> 	funct3, 
  unset     			=> 	unset
  );
  
  U3: entity work.program_memory
  Port map (  
   CLK					=> 	clock,
	WE 					=> 	enable,
  load_addr				=> 	pc_in,
  write_addr  			=> 	write_addr,
  data_in				=> 	data_in,  
  dataout			 	=> 	instr_in
  );
  
  U2: entity work.instr_buffer
  Port map (
  CLK						=> 	clock,
  RESET					=> 	reset,
  enable 		 	 	=> 	enable,
  addr_in				=> 	addr_in,
  addr_out           => 	addr_out,
  instr_in           => 	instr_in,  
  instr_out          => 	instr_out
  );
  
 U1: entity work.pc_buffer
 Port map (
  CLK						=> 	clock,
  RESET					=> 	reset,
  enable 		 		=> 	enable,
  addr_in				=> 	addr_in,
  addr_out         	=> 	addr_out,
  pc_in              => 	pc_in,  
  pc_out             => 	pc_out_sig 
	);

end Structural;
