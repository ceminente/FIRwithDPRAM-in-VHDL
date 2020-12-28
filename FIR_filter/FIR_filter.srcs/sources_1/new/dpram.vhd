----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2020 12:05:18
-- Design Name: 
-- Module Name: dpram - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- ipbus_dpram
--
-- Generic 32b wide dual-port memory with ipbus access on one port

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity dpram is
	generic(
	    N      : integer := 16;
		ADDR_WIDTH: natural
	);
	Port(
		clk: in std_logic;
		rst: in std_logic;
		we: in std_logic := '0';
		d: in std_logic_vector(N-1 downto 0) := (others => '0');
		q: out std_logic_vector(N-1 downto 0);
		addr: in std_logic_vector(ADDR_WIDTH - 1 downto 0)
	);
	
end dpram;

architecture rtl of dpram is

	type ram_array is array(2 ** ADDR_WIDTH - 1 downto 0) of std_logic_vector(15 downto 0);
	shared variable ram: ram_array;

begin
	
	process(clk)
	begin
		if rising_edge(clk) then
			if we = '1' then
				ram(to_integer(unsigned(addr))) := d;
			end if;
			q <= ram(to_integer(unsigned(addr)));
		end if;
	end process;
	
end rtl;