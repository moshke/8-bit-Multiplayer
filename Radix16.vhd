library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


entity Radix16 is
port ( clk   : in  std_logic;
       rst   : in  std_logic;
	    start : in  std_logic;
	    a     : in  std_logic_vector(15   downto 0);
	    b     : in  std_logic_vector(15   downto 0);
	    res   : out std_logic_vector(31 downto 0);
	    done  : out std_logic
	  );
end entity Radix16;



architecture arc_Radix of Radix16 is

type fsm_st is (s0,s1);
signal ns: fsm_st;
signal p : std_logic_vector(31 downto 0);
begin
	
	process(clk,rst) is
	variable ra , ra3 , ra5 , ra7 : std_logic_vector(31 downto 0);
	variable rb : std_logic_vector(15 downto 0);
	variable acc: std_logic_vector(31 downto 0);
	variable rb_v : std_logic_vector(31 downto 0);
	variable curr_4 : std_logic_vector(3 downto 0);
	variable sh_acc , ld_clr , done_v , carry , next_carry : std_logic;
	variable end_op : boolean;
	variable cs: fsm_st;
	
	
	begin
	
		if(rst='0') then
			cs:=s0;
			ra:=(others=>'0');
			rb:=(others=>'0');
			ra3:=(others=>'0');
			ra5:=(others=>'0');
			ra7:=(others=>'0');
			acc:=(others=>'0');
			
	    elsif rising_edge(clk) then
		 
		   end_op:=(rb=0) and (carry='0');
			sh_acc:='0'; 
			ld_clr:='0';
			done_v:='0';
			ns<=cs;
			case cs is
			when s0=> if(start='1') then	
						 ns<=s1;
						 sh_acc:='0';
						 ld_clr:='1';
						 end if;
			when s1=> if (not end_op) then	
						 sh_acc:='1'; 
						 else 
						 ns<=s0;
						 done_v:='1';
						 end if;
			when others => null;
			end case;
			
			cs:=ns;
			next_carry:='0';
			curr_4:= rb(3 downto 0) +carry;
			case curr_4 is 
				when x"0" => p<=(others=>'0');
				next_carry := '0' ;
				when x"1" => p<=ra;
				next_carry := '0' ;
				when x"2" => p<=ra(30 downto 0) & '0';
				next_carry := '0' ;
				when x"3" => p<=ra3;
				next_carry := '0' ;
				when x"4" => p<=ra(29 downto 0) & "00";
				next_carry := '0' ;
				when x"5" => p<=ra5;
				next_carry := '0' ;
				when x"6" => p<=ra3(30 downto 0) & '0';
				next_carry := '0' ;
				when x"7" => p<=ra7;
				next_carry := '0' ;
				when x"8" => p<=ra(27 downto 0) & "0000";
				next_carry := '0' ;
				when x"9" => p<=- ra7;
			
				next_carry := '1' ;
				
				when x"A" => p<= -(ra3(30 downto 0) & '0');
				next_carry:='1';
				when x"B" => p<= - ra5;
				next_carry:='1';
				when x"C" => p<=-(ra(29 downto 0) & "00") ;
				next_carry:='1';
				when x"D" => p<= - ra3;
				next_carry:='1';
				when x"E" => p<= - (ra(30 downto 0) & '0');
				next_carry:='1';
				when x"F" => p<= -ra ;
				next_carry:='1';
				when others => null;
				end case;
				carry:=next_carry;
		
            --rb_v<=(others=>rb(0));    
			   --p<=rb_v and ra;
				
				if(ld_clr='1') then
				
				ra:= conv_std_logic_vector(0,16) & a;
				rb:=b;
					
				acc:=(others=>'0');
				
				elsif (sh_acc='1') then
				rb:=x"0" & rb(15 downto 4);
				ra:= ra(27 downto 0)& x"0" ;
				acc:=acc + p;
				
				end if;
							ra3:=ra(30 downto 0) & "0"+ra  ;
							ra5:=ra(29 downto 0) & "00"+ra ;
							ra7:=ra(28 downto 0) & "000"-ra ;
							
							
				res<=acc;
				done<=done_v;
				end if;
				end process;		
end architecture arc_Radix;			
	  
	   