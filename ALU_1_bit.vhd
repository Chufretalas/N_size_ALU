LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE work.my_types.ALL;

ENTITY ALU_1_bit IS

    PORT (
        i_A : IN STD_LOGIC;
        i_B : IN STD_LOGIC;
        i_A_Invert : IN STD_LOGIC;
        i_B_Invert : IN STD_LOGIC;
        i_Carry_In : IN STD_LOGIC;
        i_Less : IN STD_LOGIC;
        i_Operation : IN T_Operations;
        o_Result : OUT STD_LOGIC;
        o_Carry_Out : OUT STD_LOGIC;
        o_Set : OUT STD_LOGIC
    );

END ENTITY ALU_1_bit;

ARCHITECTURE RTL OF ALU_1_bit IS

    SIGNAL w_Treated_A, w_Treated_B, w_And_Result, w_Or_Result, w_Adder_Result : STD_LOGIC;

BEGIN
    w_Treated_A <= i_A WHEN i_A_Invert = '0' ELSE
        NOT i_A;
    w_Treated_B <= i_B WHEN i_B_Invert = '0' ELSE
        NOT i_B;

    w_And_Result <= w_Treated_A AND w_Treated_B;
    w_OR_Result <= w_Treated_A OR w_Treated_B;

    adder : ENTITY work.Adder
        PORT MAP(
            i_Data_0 => w_Treated_A,
            i_Data_1 => w_Treated_B,
            i_Carry_In => i_Carry_In,
            o_Result => w_Adder_Result,
            o_Carry_Out => o_Carry_Out
        );

    o_Set <= w_Adder_Result;

    WITH i_Operation SELECT
        o_Result <= w_And_Result WHEN OP_AND,
        w_OR_Result WHEN OP_OR,
        w_Adder_Result WHEN OP_Adder,
        i_Less WHEN OP_Less,
        '0' WHEN OTHERS;
END RTL;