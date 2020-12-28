----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2018 10:18:50 AM
-- Design Name: 
-- Module Name: tb_fir - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

USE std.textio.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

--USE IEEE.STD_LOGIC_ARITH.ALL;

entity tb_fir is
    generic(N      : integer := 16
            );
end tb_fir;

architecture Behavioral of tb_fir is

component fir is
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0)); 
end component;

signal xin : std_logic_vector(N-1 downto 0) := std_logic_vector(to_signed(2048,N));
signal yout : std_logic_vector(N-1 downto 0);
signal clk : std_logic := '0';
signal rst : std_logic := '1';
constant clk_period : time := 10ps;

begin

uut : fir port map(clk => clk, rst => rst, x_in => xin, y_out => yout);

-- Clock process definitions
clk_process : process
begin
    if rst = '1' then
        clk <= '0';
        wait for clk_period;
        rst <= '0';
        clk <= not clk;
        wait for clk_period/2;
    else
        clk <= not clk;
        wait for clk_period/2;
    end if;
end process;

-- Stimulus process
--   stim_proc: process
--   begin       
--      wait for 8*clk_period;
--        for value in (1915, 11617, 13463, 17757, 15391,  5605, 22,   521,  -302,  -385) loop
--            xin <= std_logic_vector(to_signed(value,16)); 
--            wait for 1*clk_period;
--        end loop;
--   end process;


end Behavioral;
