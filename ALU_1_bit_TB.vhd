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
        r_Operation <= OP_AND;
        r_A_Invert <= '0';
        r_B_Invert <= '0';

        r_A <= '0';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' REPORT "Failed Test 1" SEVERITY failure;

        r_A <= '1';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' REPORT "Failed Test 2" SEVERITY failure;

        r_A <= '0';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' REPORT "Failed Test 3" SEVERITY failure;

        r_A <= '1';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' REPORT "Failed Test 4" SEVERITY failure;

        ---------------------------- TESTING OR - Operation = OP_OR && A_Invert = 0 && B_Invert = 0 ----------------------------
        r_Operation <= OP_OR;
        r_A_Invert <= '0';
        r_B_Invert <= '0';

        r_A <= '0';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' REPORT "Failed Test 5" SEVERITY failure;

        r_A <= '1';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' REPORT "Failed Test 6" SEVERITY failure;

        r_A <= '0';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' REPORT "Failed Test 7" SEVERITY failure;

        r_A <= '1';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' REPORT "Failed Test 8" SEVERITY failure;

        ---------------------------- TESTING NAND - Operation = OP_OR && A_Invert = 1 && B_Invert = 1 ----------------------------
        r_Operation <= OP_OR;
        r_A_Invert <= '1';
        r_B_Invert <= '1';

        r_A <= '0';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' REPORT "Failed Test 9" SEVERITY failure;

        r_A <= '1';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' REPORT "Failed Test 10" SEVERITY failure;

        r_A <= '0';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' REPORT "Failed Test 11" SEVERITY failure;

        r_A <= '1';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' REPORT "Failed Test 12" SEVERITY failure;

        ---------------------------- TESTING NOR - Operation = OP_AND && A_Invert = 1 && B_Invert = 1 ----------------------------
        r_Operation <= OP_AND;
        r_A_Invert <= '1';
        r_B_Invert <= '1';

        r_A <= '0';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' REPORT "Failed Test 13" SEVERITY failure;

        r_A <= '1';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' REPORT "Failed Test 14" SEVERITY failure;

        r_A <= '0';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' REPORT "Failed Test 15" SEVERITY failure;

        r_A <= '1';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' REPORT "Failed Test 16" SEVERITY failure;

        ---------------------------- TESTING Adder - Operation = OP_AND && A_Invert = 1 && B_Invert = 1 ----------------------------
        r_Operation <= OP_Adder;
        r_A_Invert <= '0';
        r_B_Invert <= '0';

        ---------------------------- Carry In == '0' ----------------------------
        r_Carry_In <= '0';

        r_A <= '0';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' AND r_Carry_Out = '0' AND r_Set = '0' REPORT "Failed Test 17" SEVERITY failure;

        r_A <= '1';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' AND r_Carry_Out = '0' AND r_Set = '1' REPORT "Failed Test 18" SEVERITY failure;

        r_A <= '0';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' AND r_Carry_Out = '0' AND r_Set = '1' REPORT "Failed Test 19" SEVERITY failure;

        r_A <= '1';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' AND r_Carry_Out = '1' AND r_Set = '0' REPORT "Failed Test 20" SEVERITY failure;

        ---------------------------- Carry In == '1' ----------------------------
        r_Carry_In <= '1';

        r_A <= '0';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' AND r_Carry_Out = '0' AND r_Set = '1' REPORT "Failed Test 21" SEVERITY failure;

        r_A <= '1';
        r_B <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' AND r_Carry_Out = '1' AND r_Set = '0' REPORT "Failed Test 22" SEVERITY failure;

        r_A <= '0';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' AND r_Carry_Out = '1' AND r_Set = '0' REPORT "Failed Test 23" SEVERITY failure;

        r_A <= '1';
        r_B <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' AND r_Carry_Out = '1' AND r_Set = '1' REPORT "Failed Test 24" SEVERITY failure;

        finish;
    END PROCESS;
END test;