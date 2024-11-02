LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.my_types.ALL;
USE std.env.finish;

ENTITY ALU_1_bit_TB IS
END ENTITY ALU_1_bit_TB;

ARCHITECTURE test OF ALU_1_bit_TB IS
    SIGNAL r_A, r_B, r_A_Invert, r_B_Invert, r_Carry_In, r_Less : STD_LOGIC := '0';
    SIGNAL r_Operation : T_Operations := OP_AND;
    SIGNAL r_Result, r_Carry_Out, r_Set : STD_LOGIC;
BEGIN

    UUT : ENTITY work.ALU_1_bit
        PORT MAP(
            i_A => r_A,
            i_B => r_B,
            i_A_Invert => r_A_Invert,
            i_B_Invert => r_B_Invert,
            i_Carry_In => r_Carry_In,
            i_Less => r_Less,
            i_Operation => r_Operation,
            o_Result => r_Result,
            o_Carry_Out => r_Carry_Out,
            o_Set => r_Set
        );

    PROCESS IS
    BEGIN
        ---------------------------- TESTING AND - Operation = OP_AND && A_Invert = 0 && B_Invert = 0 ----------------------------
        r_A <= '0';
        r_B <= '0';
        WAIT FOR 2 ns;
        REPORT "Test 1";
        ASSERT r_Result = '0' SEVERITY failure;

        r_A <= '1';
        r_B <= '0';
        WAIT FOR 2 ns;
        REPORT "Test 2";
        ASSERT r_Result = '0' SEVERITY failure;

        r_A <= '0';
        r_B <= '1';
        WAIT FOR 2 ns;
        REPORT "Test 3";
        ASSERT r_Result = '0' SEVERITY failure;

        r_A <= '1';
        r_B <= '1';
        WAIT FOR 2 ns;
        REPORT "Test 4";
        ASSERT r_Result = '1' SEVERITY failure;

        ---------------------------- TESTING OR - Operation = OP_OR && A_Invert = 0 && B_Invert = 0 ----------------------------
        r_Operation <= OP_OR;

        r_A <= '0';
        r_B <= '0';
        WAIT FOR 2 ns;
        REPORT "Test 5";
        ASSERT r_Result = '0' SEVERITY failure;

        r_A <= '1';
        r_B <= '0';
        WAIT FOR 2 ns;
        REPORT "Test 6";
        ASSERT r_Result = '1' SEVERITY failure;

        r_A <= '0';
        r_B <= '1';
        WAIT FOR 2 ns;
        REPORT "Test 7";
        ASSERT r_Result = '1' SEVERITY failure;

        r_A <= '1';
        r_B <= '1';
        WAIT FOR 2 ns;
        REPORT "Test 8";
        ASSERT r_Result = '1' SEVERITY failure;

        ---------------------------- TESTING NAND - Operation = OP_OR && A_Invert = 1 && B_Invert = 1 ----------------------------
        r_A_Invert <= '1';
        r_B_Invert <= '1';

        r_A <= '0';
        r_B <= '0';
        WAIT FOR 2 ns;
        REPORT "Test 1";
        ASSERT r_Result = '1' SEVERITY failure;

        r_A <= '1';
        r_B <= '0';
        WAIT FOR 2 ns;
        REPORT "Test 2";
        ASSERT r_Result = '1' SEVERITY failure;

        r_A <= '0';
        r_B <= '1';
        WAIT FOR 2 ns;
        REPORT "Test 3";
        ASSERT r_Result = '1' SEVERITY failure;

        r_A <= '1';
        r_B <= '1';
        WAIT FOR 2 ns;
        REPORT "Test 4";
        ASSERT r_Result = '0' SEVERITY failure;

        --#TODO: write a bunch more tests
        finish;
    END PROCESS;
END test;