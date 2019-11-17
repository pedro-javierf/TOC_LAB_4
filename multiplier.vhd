library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity ASM_multiplier is
    port( reset, CLOCK_24, init : in  std_logic;
          SW               : in  std_logic_vector(9 downto 0);
          done             : out std_logic;
			 LEDR					: out std_logic_vector(9 downto 0);
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

    signal status  : std_logic_vector(W_STATUS-1  downto 0);
    signal control : std_logic_vector(W_CONTROL-1 downto 0);
begin
	
    U_CNTRL: controller
        port map(CLOCK_24, '0', '1', status, control, done);

    U_DP: data_path
        port map(CLOCK_24, '0', SW(3 downto 0), SW(7 downto 4), control, status, LEDR(7 downto 0));
		  

end arch_ASM_mult;
