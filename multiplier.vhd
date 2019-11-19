library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity ASM_multiplier is
    port( reset, clk, init : in  std_logic;
          a_in, b_in       : in  std_logic_vector(W_FACTORS-1 downto 0);
          done             : out std_logic;
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
    
    component displays
    Port ( 
        rst : in STD_LOGIC;
        clk : in STD_LOGIC; 
        velocidad : in  STD_LOGIC_VECTOR (1 downto 0);      
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
     );
     end component displays;

    component conv_7seg
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
           display : out  STD_LOGIC_VECTOR (6 downto 0));
end component conv_7seg;

    signal status  : std_logic_vector(W_STATUS-1  downto 0);
    signal control : std_logic_vector(W_CONTROL-1 downto 0);
    signal display : std_logic_vector(6 downto 0);
begin

    U_CNTRL: controller
        port map(clk, reset, init, status, control, done);

    U_DP: data_path
        port map(clk, reset, a_in, b_in, control, status, r);

    DSP: displays port map(reset, clk, "11", display, "1100");
    

end arch_ASM_mult;
