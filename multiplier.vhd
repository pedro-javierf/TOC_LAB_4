library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity ASM_multiplier is
    port( reset, CLOCK_24, init : in  std_logic;
          SW               : in  std_logic_vector(9 downto 0);
          done             : inout std_logic;
			 LEDR					: out std_logic_vector(9 downto 0);
			 LEDG 				: out std_logic_vector(7 downto 0);
			 KEY					: in std_logic_vector(3 downto 0);
			 HEX0 				: out std_logic_vector(6 downto 0);
			 HEX1 				: out std_logic_vector(6 downto 0);
          r                : out std_logic_vector(W_RESULT-1  downto 0) );
end ASM_multiplier;


architecture arch_ASM_mult of ASM_multiplier is
    component controller
        port( clk, reset, init : in std_logic;
              status           : in  std_logic_vector(W_STATUS-1  downto 0);
              control          : out std_logic_vector(W_CONTROL-1 downto 0);
              done             : out std_logic );
    end component controller;
    
    component data_path
        port( clk, reset : in  std_logic;
              a_in, b_in : in  std_logic_vector(W_FACTORS-1 downto 0);
              control    : in  std_logic_vector(W_CONTROL-1 downto 0);
              status     : out std_logic_vector(W_STATUS-1  downto 0);
              r          : out std_logic_vector(W_RESULT-1  downto 0) );
    end component data_path;
	 
	 component conv_7seg
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
           display : out  STD_LOGIC_VECTOR (6 downto 0));
	 end component conv_7seg;

    signal status  : std_logic_vector(W_STATUS-1  downto 0);
    signal control : std_logic_vector(W_CONTROL-1 downto 0);
	 signal output  : std_logic_vector(W_RESULT-1  downto 0);
begin
	
	 LEDG(0) <= done;
	 LEDR(7 downto 0) <= output;
	
	 --HEX0 <= 
	
    U_CNTRL: controller
        port map(CLOCK_24, not(KEY(0)), not(KEY(3)), status, control, done);

    U_DP: data_path
        port map(CLOCK_24, not(KEY(0)), SW(3 downto 0), SW(7 downto 4), control, status, output);
		  
	 LCD_1: conv_7seg port map(output(3 downto 0), HEX0);
	 LCD_2: conv_7seg port map(output(7 downto 4), HEX1);

end arch_ASM_mult;
