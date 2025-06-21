LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.my_types.ALL;

ENTITY N_size_ALU IS

    GENERIC (
        SIZE : INTEGER -- the bit width, should be > 2
    );

    PORT (
        i_B_Negate : IN STD_LOGIC;
        i_A_Invert : IN STD_LOGIC;
        i_Operation : IN T_Operations;
        i_As : IN STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
        i_Bs : IN STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
        o_Results : OUT STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
        o_Zero : OUT STD_LOGIC;
        o_Overflow : OUT STD_LOGIC
    );
END ENTITY N_size_ALU;

ARCHITECTURE RTL OF N_size_ALU IS

    SIGNAL w_Carry_Bridges : STD_LOGIC_VECTOR(SIZE - 2 DOWNTO 0);
    SIGNAL w_Less_Bridge : STD_LOGIC;
    SIGNAL r_All_Zeroes : STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0) := (OTHERS => '0'); -- This is very very ugly, but it was the only working sollution I was capable of making
BEGIN

    FIRST_ULA : ENTITY work.ALU_1_Bit
        PORT MAP(
            i_A => i_As(0),
            i_B => i_Bs(0),
            i_A_Invert => i_A_Invert,
            i_B_Invert => i_B_Negate,
            i_Carry_In => i_B_Negate,
            i_Less => w_Less_Bridge,
            i_Operation => i_Operation,
            o_Result => o_Results(0),
            o_Carry_Out => w_Carry_Bridges(0),
            o_Set => OPEN
        );

    GEN_ULA_CHAIN : FOR i IN 1 TO SIZE - 2 GENERATE
        ULA_X : ENTITY work.ALU_1_Bit
            PORT MAP(
                i_A => i_As(i),
                i_B => i_Bs(i),
                i_A_Invert => i_A_Invert,
                i_B_Invert => i_B_Negate,
                i_Carry_In => w_Carry_Bridges(i - 1),
                i_Less => '0',
                i_Operation => i_Operation,
                o_Result => o_Results(i),
                o_Carry_Out => w_Carry_Bridges(i),
                o_Set => OPEN
            );
    END GENERATE GEN_ULA_CHAIN;

    LAST_ULA : ENTITY work.ALU_1_Bit
        PORT MAP(
            i_A => i_As(SIZE - 1),
            i_B => i_Bs(SIZE - 1),
            i_A_Invert => i_A_Invert,
            i_B_Invert => i_B_Negate,
            i_Carry_In => w_Carry_Bridges(SIZE - 2),
            i_Less => '0',
            i_Operation => i_Operation,
            o_Result => o_Results(SIZE - 1),
            o_Carry_Out => o_Overflow,
            o_Set => w_Less_Bridge
        );

    o_Zero <= '1' WHEN o_Results = r_All_Zeroes ELSE
        '0';
END RTL;