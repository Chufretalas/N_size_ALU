LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.my_types.ALL;
USE std.env.finish;

ENTITY N_size_ALU_TB IS
END ENTITY N_size_ALU_TB;

ARCHITECTURE test OF N_size_ALU_TB IS

    CONSTANT SIZE : INTEGER := 16;

    SIGNAL r_B_Negate, r_A_Invert : STD_LOGIC := '0';
    SIGNAL r_Operation : T_Operations := OP_AND;
    SIGNAL r_As, r_Bs : STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL w_Results : STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
    SIGNAL w_Zero, w_Overflow : STD_LOGIC;
BEGIN

    UUT : ENTITY work.N_size_ALU
        GENERIC MAP(
            SIZE => SIZE
        )
        PORT MAP(
            i_B_Negate => r_B_Negate,
            i_A_Invert => r_A_Invert,
            i_Operation => r_Operation,
            i_As => r_As,
            i_Bs => r_Bs,
            o_Results => w_Results,
            o_Zero => w_Zero,
            o_Overflow => w_Overflow
        );

    PROCESS IS
    BEGIN
        WAIT FOR 2 ns;
        -- Adding (A + B)
        r_B_Negate <= '0';
        r_A_Invert <= '0';
        r_Operation <= OP_Adder;

        r_As <= "0000000000000001";
        r_Bs <= "0000000000000001";
        WAIT FOR 2 ns;
        ASSERT w_Results = "0000000000000010" REPORT "Failed Test 1" SEVERITY failure;

        r_As <= "0000000000000001";
        r_Bs <= "0000000000111111";
        WAIT FOR 2 ns;
        ASSERT w_Results = "0000000001000000" REPORT "Failed Test 2" SEVERITY failure;

        r_As <= "0000001001010001";
        r_Bs <= "0001000001110000";
        WAIT FOR 2 ns;
        ASSERT w_Results = "0001001011000001" REPORT "Failed Test 3" SEVERITY failure;

        -- Subtracting (A - B)
        r_B_Negate <= '1';
        r_A_Invert <= '0';
        r_Operation <= OP_Adder;
        r_As <= "0000000000000111"; -- 7
        r_Bs <= "0000000000000101"; -- 5
        WAIT FOR 2 ns;
        ASSERT w_Results = "0000000000000010" REPORT "Failed Test 4" SEVERITY failure;

        -- Equal (A == B)
        r_B_Negate <= '1';
        r_A_Invert <= '0';
        r_Operation <= OP_Adder;
        r_As <= "0000000000000111";
        r_Bs <= "0000000000000111";
        WAIT FOR 2 ns;
        ASSERT w_Zero = '1' REPORT "Failed Test 5" SEVERITY failure;

        r_As <= "0000100000000111";
        r_Bs <= "0000000000000111";
        WAIT FOR 2 ns;
        ASSERT w_Zero = '0' REPORT "Failed Test 6" SEVERITY failure;

        r_As <= "0000100000000111";
        r_Bs <= "0010000000000111";
        WAIT FOR 2 ns;
        ASSERT w_Zero = '0' REPORT "Failed Test 7" SEVERITY failure;

        -- Less (A < B)
        r_B_Negate <= '1';
        r_A_Invert <= '0';
        r_Operation <= OP_Less;
        r_As <= "0000000000000111";
        r_Bs <= "0000000000000111";
        WAIT FOR 2 ns;
        ASSERT w_Results(0) = '0' REPORT "Failed Test 8" SEVERITY failure;

        r_As <= "0000100000000111";
        r_Bs <= "0000000000000111";
        WAIT FOR 2 ns;
        ASSERT w_Results(0) = '0' REPORT "Failed Test 9" SEVERITY failure;

        r_As <= "0000100000000111";
        r_Bs <= "0010000000000111";
        WAIT FOR 2 ns;
        ASSERT w_Results(0) = '1' REPORT "Failed Test 10" SEVERITY failure;

        r_As <= "0000000000001000";
        r_Bs <= "0000000000001001";
        WAIT FOR 2 ns;
        ASSERT w_Results(0) = '1' REPORT "Failed Test 11" SEVERITY failure;

        -- Logic (A AND B)
        r_B_Negate <= '0';
        r_A_Invert <= '0';
        r_Operation <= OP_AND;
        r_As <= "0101000000000000";
        r_Bs <= "0011000000000000";
        WAIT FOR 2 ns;
        ASSERT w_Results = "0001000000000000" REPORT "Failed Test 12" SEVERITY failure;

        -- Logic (A OR B)
        r_B_Negate <= '0';
        r_A_Invert <= '0';
        r_Operation <= OP_OR;
        r_As <= "0101000000000000";
        r_Bs <= "0011000000000000";
        WAIT FOR 2 ns;
        ASSERT w_Results = "0111000000000000" REPORT "Failed Test 13" SEVERITY failure;

        -- Logic (A NAND B)
        r_B_Negate <= '1';
        r_A_Invert <= '1';
        r_Operation <= OP_OR;
        r_As <= "0101000000000000";
        r_Bs <= "0011000000000000";
        WAIT FOR 2 ns;
        ASSERT w_Results = "1110111111111111" REPORT "Failed Test 14" SEVERITY failure;

        -- Logic (A NOR B)
        r_B_Negate <= '1';
        r_A_Invert <= '1';
        r_Operation <= OP_AND;
        r_As <= "0101000000000000";
        r_Bs <= "0011000000000000";
        WAIT FOR 2 ns;
        ASSERT w_Results = "1000111111111111" REPORT "Failed Test 15" SEVERITY failure;

        -- Overflow (A + B)
        r_B_Negate <= '0';
        r_A_Invert <= '0';
        r_Operation <= OP_Adder;

        r_As <= "1111111111111111";
        r_Bs <= "0000000000000001";
        WAIT FOR 2 ns;
        ASSERT w_Overflow = '1' REPORT "Failed Test 16" SEVERITY failure;

        r_As <= "1111111111111111";
        r_Bs <= "0000000000000010";
        WAIT FOR 2 ns;
        ASSERT w_Overflow = '1' REPORT "Failed Test 17" SEVERITY failure;

        r_As <= "0000000000000001";
        r_Bs <= "1111111111111110";
        WAIT FOR 2 ns;
        ASSERT w_Overflow = '0' REPORT "Failed Test 18" SEVERITY failure;

        finish;
    END PROCESS;

END test;