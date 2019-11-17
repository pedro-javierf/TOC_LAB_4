library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity data_path is
    port( clk, reset : in  std_logic;
          a_in, b_in : in  std_logic_vector (W_FACTORS-1 downto 0);
          control    : in  std_logic_vector (W_CONTROL-1 downto 0);
          status     : out std_logic_vector (W_STATUS-1  downto 0);
          r          : out std_logic_vector (W_RESULT-1  downto 0) );
end data_path;

architecture arch_dp of data_path is

    component asynch_reg
        generic (n: natural := 8);
        port( clk, rst, load : in  std_logic;
              din            : in  std_logic_vector (n-1 downto 0);
              dout           : out std_logic_vector (n-1 downto 0) );
    end component asynch_reg;
	
    component adder_sub
        generic( n: natural := 8 );
        port( a   : in std_logic_vector(n-1 downto 0);
              b   : in std_logic_vector(n-1 downto 0);
              op  : in std_logic;
              res : out std_logic_vector(n-1 downto 0) );
    end component adder_sub;
    
    component left_right_shift_reg
        generic (n: natural := 6);
        port( clk, reset, load : in  std_logic;
              r_shf, l_shf     : in  std_logic;
              data_in          : in  std_logic_vector(n-1 downto 0);    
              data_out         : out std_logic_vector(n-1 downto 0) );
    end component left_right_shift_reg;

    -- INTERMEDIATE SIGNALS...
   signal op_a, op_b: std_logic_vector(W_FACTORS-1 downto 0);
	signal op_n, op_acc, substraction, acc_plus_a: std_logic_vector(W_RESULT-1 downto 0);
	signal mux_n_out, mux_acc_out: std_logic_vector(W_RESULT-1 downto 0);
	
	signal num_zero: std_logic_vector(W_RESULT-1 downto 0):= (others => '0');
	signal  num_one: std_logic_vector(W_RESULT-1 downto 0):= (others => '0');
	signal num_four: std_logic_vector(W_RESULT-1 downto 0):= (others => '0');
	
	
	-- Result of the multiplication
	
	
begin
	r <= op_acc;
	num_one(0) <= '1';
	num_four(2) <= '1';

    -- MODULES AND INTERCONNECTIONS...
	
	-- Firstly instantiate as many elements as needed
	REG_A: left_right_shift_reg generic map(n => W_FACTORS)
								port map(clk, reset, control(ld_ra), '0', control(shl_ra), a_in, op_a);
	
	REG_B: left_right_shift_reg generic map(n => W_FACTORS)
								port map(clk, reset, control(ld_rb), control(shr_rb), '0', b_in, op_b);
	
	
	REG_N: asynch_reg   generic map(n => W_RESULT)
						port map(clk, reset, control(ld_rn), mux_n_out, op_n);
	
	REG_ACC: asynch_reg generic map(n => W_RESULT)
						port map(clk, reset, control(ld_racc), mux_acc_out, op_acc);
	
	
	SUB: adder_sub  generic map(n => W_RESULT)
					port map(op_n, num_one, '0', substraction);
	
	ADD: adder_sub  generic map(n => W_RESULT)
					port map("0000"&op_a, op_acc, '1', acc_plus_a);

	process(control,substraction,acc_plus_a)
	begin
		-- Multiplexors
		if(control(mux_n) = '0')then
			mux_n_out <= substraction;
		else
			mux_n_out <= num_four;
		end if;
		
		if(control(mux_acc) = '0')then
			mux_n_out <= acc_plus_a;
		else
			mux_n_out <= num_zero;
		end if;
	end process;
	
	process(op_b,op_n)
	begin
		-- Comparators
		if('1'=op_b(0))then
			status(b0)<='1';
		else
			status(b0)<='0';
		end if;
		
		if(num_zero=op_n)then
			status(zero)<='1';
		else
			status(zero)<='0';
		end if;
		
	end process;
		
	

end arch_dp;
