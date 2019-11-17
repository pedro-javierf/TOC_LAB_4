package definitions is
    constant W_FACTORS : integer := 4;
    constant W_RESULT  : integer := (W_FACTORS*2);

    -- Control Constants
    constant ld_ra     : integer := 0;
    constant ld_rb     : integer := 1;
    constant ld_rn     : integer := 2;
    constant ld_racc   : integer := 3;
    constant mux_n     : integer := 4;   -- mux_n   = '1' for external input
    constant mux_acc   : integer := 5;   -- mux_acc = '0' for increment
    constant shl_ra    : integer := 6;
    constant shr_rb    : integer := 7;
    constant W_CONTROL : integer := 8;   -- Control vector width

    -- Status Constants
    constant zero      : integer := 0;   -- reg n = 0?
    constant b0        : integer := 1;   -- lsb reg b
    constant W_STATUS  : integer := 2;   -- Status vector width
end package definitions;