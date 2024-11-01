LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.env.finish;

ENTITY Adder_TB IS
END ENTITY Adder_TB;

ARCHITECTURE test OF Adder_TB IS
    SIGNAL r_Data_0, r_Data_1, r_Carry_In : STD_LOGIC := '0';
    SIGNAL r_Result, r_Carry_Out : STD_LOGIC;
BEGIN

    UUT : ENTITY work.Adder
        PORT MAP(
            i_Data_0 => r_Data_0,
            i_Data_1 => r_Data_1,
            i_Carry_In => r_Carry_In,
            o_Result => r_Result,
            o_Carry_Out => r_Carry_Out
        );

    PROCESS IS
    BEGIN
        ---------------------------- Carry In == '0' ----------------------------
        r_Data_0 <= '0';
        r_Data_1 <= '0';
        r_Carry_In <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' AND r_Carry_Out = '0' SEVERITY failure;

        r_Data_0 <= '1';
        r_Data_1 <= '0';
        r_Carry_In <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' AND r_Carry_Out = '0' SEVERITY failure;

        r_Data_0 <= '0';
        r_Data_1 <= '1';
        r_Carry_In <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' AND r_Carry_Out = '0' SEVERITY failure;

        r_Data_0 <= '1';
        r_Data_1 <= '1';
        r_Carry_In <= '0';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' AND r_Carry_Out = '1' SEVERITY failure;

        ---------------------------- Carry In == '1' ----------------------------
        r_Data_0 <= '0';
        r_Data_1 <= '0';
        r_Carry_In <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' AND r_Carry_Out = '0' SEVERITY failure;

        r_Data_0 <= '1';
        r_Data_1 <= '0';
        r_Carry_In <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' AND r_Carry_Out = '1' SEVERITY failure;

        r_Data_0 <= '0';
        r_Data_1 <= '1';
        r_Carry_In <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '0' AND r_Carry_Out = '1' SEVERITY failure;

        r_Data_0 <= '1';
        r_Data_1 <= '1';
        r_Carry_In <= '1';
        WAIT FOR 2 ns;
        ASSERT r_Result = '1' AND r_Carry_Out = '1' SEVERITY failure;

        finish;
    END PROCESS;
END test;