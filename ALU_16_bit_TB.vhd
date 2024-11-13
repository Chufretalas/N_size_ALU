LIBRARY ieee;
use ieee.std_logic_1164.all;
USE work.my_types.ALL;
USE std.env.finish;

ENTITY ALU_16_bit_TB IS
END ENTITY ALU_16_bit_TB;

ARCHITECTURE test OF ALU_16_bit_TB IS
    SIGNAL r_B_Negate, r_A_Invert : STD_LOGIC := '0';
    SIGNAL r_Operation : T_Operations := OP_AND;
    SIGNAL r_As, r_Bs : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    SIGNAL w_Results : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL w_Zero : STD_LOGIC;
BEGIN

    UUT : ENTITY work.ALU_16_bit_Top
        PORT MAP(
            i_B_Negate => r_B_Negate,
            i_A_Invert => r_A_Invert,
            i_Operation => r_Operation,
            i_As => r_As,
            i_Bs => r_Bs,
            o_Results => w_Results,
            o_Zero => w_Zero
        );

    PROCESS IS
    BEGIN
        WAIT FOR 2 ns;
        finish;
    END PROCESS;

END test;