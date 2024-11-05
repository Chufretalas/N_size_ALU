LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE work.my_types.ALL;

ENTITY ALU_16_bit_Top IS
    PORT (
        i_B_Negate : IN STD_LOGIC;
        i_A_Invert : IN STD_LOGIC;
        i_Operation : IN T_Operations;
        i_As : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        i_Bs : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        o_Results : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        o_Zero : OUT STD_LOGIC;
    );
END ENTITY ALU_16_bit_Top;

ARCHITECTURE RTL OF ALU_16_bit_Top IS

    SIGNAL w_Carry_Bridges : STD_LOGIC_VECTOR(14 DOWNTO 0);
    SIGNAL w_Less_Bridge, w_Zero_OR : STD_LOGIC;

    ULA_1 : ENTITY work.ALU_1_bit
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

    GEN_ULA_CHAIN : FOR i IN 1 TO 14 GENERATE
        ULA_X : ENTITY work.ALU_1_bit
            PORT MAP(
                i_A => i_As(i),
                i_B => i_Bs(i),
                i_A_Invert => i_A_Invert,
                i_B_Invert => i_B_Negate,
                i_Carry_In => w_Carry_Bridges(i - 1),
                i_Less => OPEN,
                i_Operation => i_Operation,
                o_Result => o_Results(i),
                o_Carry_Out => w_Carry_Bridges(i),
                o_Set => OPEN
            );
    END GENERATE GEN_ULA_CHAIN;

    ULA_16 : ENTITY work.ALU_1_bit
        PORT MAP(
            i_A => i_As(15),
            i_B => i_Bs(15),
            i_A_Invert => i_A_Invert,
            i_B_Invert => i_B_Negate,
            i_Carry_In => w_Carry_Bridges(14),
            i_Less => OPEN,
            i_Operation => i_Operation,
            o_Result => o_Results(15),
            o_Carry_Out => OPEN,
            o_Set => w_Less_Bridge
        );
    
    o_Zero <= '1' when o_Results = "0000000000000000" else '0';
    
BEGIN

END RTL;