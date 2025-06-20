library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_types.all;

entity Go_Board_ALU_Top is
    port (
        i_Clk      : in std_logic;
        i_Switch_1 : in std_logic;
        i_Switch_2 : in std_logic;
        i_Switch_3 : in std_logic;
        i_Switch_4 : in std_logic;

        o_LED_1 : out std_logic;
        o_LED_2 : out std_logic;
        o_LED_3 : out std_logic;
        o_LED_4 : out std_logic;

        o_Segment1_A : out std_logic;
        o_Segment1_B : out std_logic;
        o_Segment1_C : out std_logic;
        o_Segment1_D : out std_logic;
        o_Segment1_E : out std_logic;
        o_Segment1_F : out std_logic;
        o_Segment1_G : out std_logic;

        o_Segment2_A : out std_logic;
        o_Segment2_B : out std_logic;
        o_Segment2_C : out std_logic;
        o_Segment2_D : out std_logic;
        o_Segment2_E : out std_logic;
        o_Segment2_F : out std_logic;
        o_Segment2_G : out std_logic
    );
end entity;

architecture rtl of Go_Board_ALU_Top is

    -- Things for the ALU instance
    signal r_B_Negate        : std_logic                    := '0';
    signal r_A_Invert        : std_logic                    := '0';
    signal r_Internal_ALU_OP : T_Operations                 := OP_AND;
    signal r_As              : std_logic_vector(3 downto 0) := "0110";
    signal r_Bs              : std_logic_vector(3 downto 0) := "1010";

    signal w_Results  : std_logic_vector(3 downto 0);
    signal w_Zero     : std_logic;
    signal w_Overflow : std_logic;

    -- Things for the debounces
    signal w_Switch_1 : std_logic;
    signal w_Switch_2 : std_logic;
    signal w_Switch_3 : std_logic;
    signal w_Switch_4 : std_logic;

    signal r_Switch_1 : std_logic;
    signal r_Switch_2 : std_logic;
    signal r_Switch_3 : std_logic;
    signal r_Switch_4 : std_logic;

    -- Things for 7-segment displays
    signal w_Segment1_A : std_logic;
    signal w_Segment1_B : std_logic;
    signal w_Segment1_C : std_logic;
    signal w_Segment1_D : std_logic;
    signal w_Segment1_E : std_logic;
    signal w_Segment1_F : std_logic;
    signal w_Segment1_G : std_logic;

    signal w_Segment2_A : std_logic;
    signal w_Segment2_B : std_logic;
    signal w_Segment2_C : std_logic;
    signal w_Segment2_D : std_logic;
    signal w_Segment2_E : std_logic;
    signal w_Segment2_F : std_logic;
    signal w_Segment2_G : std_logic;

    signal w_Display1_Value       : std_logic_vector(3 downto 0);
    signal w_Display2_Value       : std_logic_vector(3 downto 0);
    signal w_Display_Results      : std_logic_vector(3 downto 0);
    signal w_Overflow_Display_Bit : std_logic;

    signal r_Top_Operation : std_logic_vector(2 downto 0) := "000";
    signal r_Display_Mode  : std_logic                    := '0'; -- '0' shows (A | B), '1' shows (overflow | result)
begin

    -- ================ Debounces ================ --
    Debounce_1 : entity work.Debounce
        port map(
            i_Clk    => i_Clk,
            i_Switch => i_Switch_1,
            o_Switch => w_Switch_1
        );

    Debounce_2 : entity work.Debounce
        port map(
            i_Clk    => i_Clk,
            i_Switch => i_Switch_2,
            o_Switch => w_Switch_2
        );

    Debounce_3 : entity work.Debounce
        port map(
            i_Clk    => i_Clk,
            i_Switch => i_Switch_3,
            o_Switch => w_Switch_3
        );

    Debounce_4 : entity work.Debounce
        port map(
            i_Clk    => i_Clk,
            i_Switch => i_Switch_4,
            o_Switch => w_Switch_4
        );
    -- ================ End Debounces ================ --

    -- ================ Displays ================ --
    SevenSeg1_Inst : entity work.Binary_To_7Segment
        port map(
            i_Clk        => i_Clk,
            i_Binary_Num => w_Display1_Value,
            o_Segment_A  => w_Segment1_A,
            o_Segment_B  => w_Segment1_B,
            o_Segment_C  => w_Segment1_C,
            o_Segment_D  => w_Segment1_D,
            o_Segment_E  => w_Segment1_E,
            o_Segment_F  => w_Segment1_F,
            o_Segment_G  => w_Segment1_G
        );

    o_Segment1_A <= not w_Segment1_A;
    o_Segment1_B <= not w_Segment1_B;
    o_Segment1_C <= not w_Segment1_C;
    o_Segment1_D <= not w_Segment1_D;
    o_Segment1_E <= not w_Segment1_E;
    o_Segment1_F <= not w_Segment1_F;
    o_Segment1_G <= not w_Segment1_G;

    SevenSeg2_Inst : entity work.Binary_To_7Segment
        port map(
            i_Clk        => i_Clk,
            i_Binary_Num => w_Display2_Value,
            o_Segment_A  => w_Segment2_A,
            o_Segment_B  => w_Segment2_B,
            o_Segment_C  => w_Segment2_C,
            o_Segment_D  => w_Segment2_D,
            o_Segment_E  => w_Segment2_E,
            o_Segment_F  => w_Segment2_F,
            o_Segment_G  => w_Segment2_G
        );

    o_Segment2_A <= not w_Segment2_A;
    o_Segment2_B <= not w_Segment2_B;
    o_Segment2_C <= not w_Segment2_C;
    o_Segment2_D <= not w_Segment2_D;
    o_Segment2_E <= not w_Segment2_E;
    o_Segment2_F <= not w_Segment2_F;
    o_Segment2_G <= not w_Segment2_G;
    -- ================ End Displays ================ --

    -- ================ End Displays ================ --
    FOUR_BIT_ULA : entity work.N_size_ALU
        generic map(
            SIZE => 4
        )
        port map(
            i_B_Negate  => r_B_Negate,
            i_A_Invert  => r_A_Invert,
            i_Operation => r_Internal_ALU_OP,
            i_As        => r_As,
            i_Bs        => r_Bs,
            o_Results   => w_Results,
            o_Zero      => w_Zero,
            o_Overflow  => w_Overflow
        );
    -- ================ End Displays ================ --

    p_Clocked : process (i_Clk)
    begin
        if rising_edge(i_Clk) then
            r_Switch_1 <= w_Switch_1;
            r_Switch_2 <= w_Switch_2;
            r_Switch_3 <= w_Switch_3;
            r_Switch_4 <= w_Switch_4;

            -- Cycles between all possible operations: AND -> OR -> NOR -> ADD -> SUB -> LESSER THAN
            if r_Switch_1 = '1' and w_Switch_1 = '0' then
                if r_Top_Operation = "101" then
                    r_Top_Operation <= "000";
                else
                    r_Top_Operation <= std_logic_vector(unsigned(r_Top_Operation) + 1);
                end if;
            end if;

            -- Changes the display mode
            if r_Switch_2 = '1' and w_Switch_2 = '0' then
                r_Display_Mode <= not r_Display_Mode;
            end if;

            -- Changes the A input
            if r_Switch_3 = '1' and w_Switch_3 = '0' then
                r_As <= std_logic_vector(unsigned(r_As) + 1);
            end if;

            -- Changes the B input
            if r_Switch_4 = '1' and w_Switch_4 = '0' then
                r_Bs <= std_logic_vector(unsigned(r_Bs) + 1);
            end if;

            -- Configures the ALU properly for each operation
            case r_Top_Operation is
                when "000" => -- AND
                    r_Internal_ALU_OP <= OP_AND;
                    r_B_Negate        <= '0';
                    r_A_Invert        <= '0';

                when "001" => -- OR
                    r_Internal_ALU_OP <= OP_OR;
                    r_B_Negate        <= '0';
                    r_A_Invert        <= '0';

                when "010" => -- NOR
                    r_Internal_ALU_OP <= OP_AND;
                    r_B_Negate        <= '1';
                    r_A_Invert        <= '1';

                when "011" => -- ADD
                    r_Internal_ALU_OP <= OP_Adder;
                    r_B_Negate        <= '0';
                    r_A_Invert        <= '0';

                when "100" => -- SUB
                    r_Internal_ALU_OP <= OP_Adder;
                    r_B_Negate        <= '1';
                    r_A_Invert        <= '0';

                when "101" => -- SLT (Lesser than)
                    r_Internal_ALU_OP <= OP_Less;
                    r_B_Negate        <= '1';
                    r_A_Invert        <= '0';
            end case;
        end if;
    end process;

    -- Applies two's complement if the operation is SUB and the result is negative (overflow == 0), otherwise it shows the result
    w_Display_Results <= std_logic_vector(unsigned(not w_Results) + 1) when (r_Top_Operation = "100" and w_Overflow = '0') else
        w_Results;

    -- Inverts the overflow if the operation is SUB so it shows 1 for a negative result and 0 for a positive one, otherwise it shows the overflow
    w_Overflow_Display_Bit <= not w_Overflow when r_Top_Operation = "100" else
        w_Overflow;

    -- Shows the A input or the overflow (or the signal if it's a SUB operation) on the left display
    w_Display1_Value <= r_As when r_Display_Mode = '0' else
        "0001" when w_Overflow_Display_Bit = '1' else
        "0000";

    -- Shows the B input or the result on the right display
    w_Display2_Value <= r_Bs when r_Display_Mode = '0' else
        w_Display_Results;

    -- Shows the current display mode
    o_LED_1 <= r_Display_Mode;

    -- Shows the current operation
    o_LED_2 <= r_Top_Operation(2);
    o_LED_3 <= r_Top_Operation(1);
    o_LED_4 <= r_Top_Operation(0);

end architecture;