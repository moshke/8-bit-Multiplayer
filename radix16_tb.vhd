library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------
entity radix16_tb is
end entity radix16_tb;

architecture arc_radix16_tb of radix16_tb is
component radix16 is
port ( clk  : in  std_logic;
       rst  : in  std_logic;
	   start: in  std_logic;
	   a    : in  std_logic_vector(15   downto 0);
	   b    : in  std_logic_vector(15  downto 0);
	   res  : out std_logic_vector(31 downto 0);
	   done : out std_logic
	  );
end component radix16;
signal clk  : std_logic:='0';
signal rst  : std_logic:='0';
signal start: std_logic:='0';
signal a    : std_logic_vector(15   downto 0):=(others=>'0');
signal b    : std_logic_vector(15  downto 0):=(others=>'0');
signal res  : std_logic_vector(31 downto 0);
signal done : std_logic;
signal correct: boolean:=false;
begin
 u1: radix16
 port map (
 		clk  => clk,
          	rst  => rst,
	        start=> start,
	        a    => a,
	        b    => b,
	        res  => res,
	        done => done
           );
 
 clk<= not clk after 10 ns;
 rst<='1' after 15 ns;
 correct<=((a*b)=res) and (done='1');
 process is
 begin
 wait until rising_edge(rst);
 wait for 10 ns;
 for i in 0 to 7 loop
	wait until rising_edge(clk);
	a<=x"34" + conv_std_logic_vector(i*17,16);
	b<=x"5a" + conv_std_logic_vector(i*15,16);
    start<='1';
    wait until rising_edge(clk);
    start<='0';
    wait until rising_edge(done);
 end loop;	
 wait;
 end process;	
end architecture arc_radix16_tb;			
	  
	   