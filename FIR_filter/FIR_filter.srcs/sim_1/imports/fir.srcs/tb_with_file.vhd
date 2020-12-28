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

USE ieee.std_logic_signed.all;
USE ieee.numeric_std.ALL;

USE std.textio.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

--USE IEEE.STD_LOGIC_ARITH.ALL;

entity tb_with_file is
--  Port ( );
end tb_with_file;

architecture Behavioral of tb_with_file is

component fir is
  generic(N      : integer := 16);
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0)
     );
end component;

signal clk,rst : std_logic;
signal x,y : std_logic_vector(15 downto 0);

constant clk_T : time := 10 ns; 
constant t_rst : time := 30 ns;

begin

uut : fir port map (clk => clk, rst => rst, x_in => x, y_out => y);

p_clk : process
begin
  clk <= '0'; wait for clk_T; clk <= '1'; wait for clk_T;
end process;

p_rst: process
begin
  rst <= '1'; wait for t_rst; rst <= '0'; wait;
end process;

p_x: process

file input  :text;
file output : text;
variable line_in: line;
variable line_out: line;
variable num_in: integer;
variable num_out: integer;

begin

file_open(input,"input/square.txt",read_mode);
file_open(output,"output/square_out.txt",write_mode);

wait until falling_edge(rst); 
 
while not (endfile(input)) loop 
  
  readline(input,line_in); 
  read(line_in,num_in);
  
  x <= std_logic_vector(to_signed(num_in, x'length));
  -- wait for read and write state
  wait until rising_edge(clk);
  wait until rising_edge(clk);
  num_out := to_integer(signed(y));

  write(line_out, num_out);
  writeline(output,line_out);

end loop;

file_close(input);
file_close(output);
wait;

end process;

end Behavioral;
