library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir is
  generic(N      : integer := 16;
          shift  : integer := 10);
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0) := (others => '0')
        );  
end fir;

architecture rtl of fir is

component FF is
   Port(
      Q : out std_logic_vector(N-1 downto 0); 
      clk :in std_logic;  
      rst : in std_logic;
      D :in  std_logic_vector(N-1 downto 0);
      we: in std_logic
   );
end component;  

component dpram is
    generic(
		ADDR_WIDTH: natural:=10
	);
    Port(
		clk: in std_logic;
		rst: in std_logic;
		we: in std_logic;
		d: in std_logic_vector(N-1 downto 0) := (others => '0');
		q: out std_logic_vector(N-1 downto 0);
		addr: in std_logic_vector(ADDR_WIDTH - 1 downto 0)
	);
end component;

signal C0,C1,C2,C3,C4 : signed(N-1 downto 0) := (others => '0');
signal Q1,Q2,Q3,Q4 : std_logic_vector(N-1 downto 0) := (others => '0');
signal x : std_logic_vector(N-1 downto 0);
signal y_shifted : std_logic_vector(N-1 downto 0);
-- write enable signal and address counter
signal we_s : std_logic;
signal addr_s: std_logic_vector(9 downto 0); --memory address
signal samples : integer;

-- finite state machine
type state is (s_idle, s_read, s_write);
signal state_fsm : state;

-- dpram output
signal dpram_s : std_logic_vector(N-1 downto 0);

begin

--filter coefficient initializations.

C0 <= to_signed(198,N);
C1 <= to_signed(208,N);
C2 <= to_signed(210,N);
C3 <= to_signed(208,N);
C4 <= to_signed(198,N);

-- flipflops(for introducing a delay).
ff1 : FF port map(Q => Q1,clk => clk,rst => rst,D => x, we=>we_s);
ff2 : FF port map(Q => Q2,clk => clk,rst => rst,D => Q1, we=>we_s);
ff3 : FF port map(Q => Q3,clk => clk,rst => rst,D => Q2, we=>we_s);
ff4 : FF port map(Q => Q4,clk => clk,rst => rst,D => Q3, we=>we_s);


-- dpram
ram : dpram port map(clk => clk, rst => rst, d => dpram_s, we => we_s, addr => addr_s);    

fsm_fir: process(clk, rst) is
	-- clk, rst: sensitivity list
	begin

		if rst = '1' then
			y_shifted <= (others => '0');
			x <= (others => '0');
			samples <= 0;
			we_s <= '0';
			state_fsm <= s_idle;


		elsif rising_edge(clk) then

			case state_fsm is
				when s_idle =>
					we_s          <= '0';
					state_fsm     <= s_read;

				when s_read =>
					x         <= std_logic_vector(signed(x_in));
					dpram_s   <= (others => '0');
					state_fsm <= s_write;
					addr_s   <= std_logic_vector(to_unsigned(samples, addr_s'length));
					we_s       <= '0';
					

				when s_write =>
				    addr_s   <= std_logic_vector(to_unsigned(samples+512, addr_s'length));
					y_shifted <= std_logic_vector(resize(SHIFT_RIGHT(C0*signed(x)+C1*signed(Q1)+C2*signed(Q2)+C3*signed(Q3)+C4*signed(Q4)+to_signed(512,2*N),shift),N));
					samples   <= samples + 1;
					if samples = 512 then
						y_shifted <= (others => '0');
						samples   <= 0;
						we_s        <= '0';
						state_fsm <= s_idle;
					else
						state_fsm <= s_read;
					end if;
					we_s       <= '1';
                    dpram_s   <= y_shifted;
                    
					
				when others =>
					state_fsm <= s_idle;

			end case;
			y_out <= y_shifted;
		end if;
	end process;
         
end rtl;
