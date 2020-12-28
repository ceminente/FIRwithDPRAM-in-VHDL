----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2018 14:27:31
-- Design Name: 
-- Module Name: FF - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity FF is
generic(N      : integer := 16);
  Port (
      Q : out std_logic_vector(N-1 downto 0); 
      clk :in std_logic;  
      rst : in std_logic;
      D :in  std_logic_vector(N-1 downto 0); 
      we: in std_logic
   );
end FF;

architecture rtl of FF is

begin


flipflop: process(clk, rst)
begin
    if rst = '1' then
        Q <= (others => '0');
    elsif(rising_edge(clk) and we='1') then
        Q <= D;
    end if;      
end process;


end rtl;
