-------------------------------------------------------------------------------
-- Based on the code from https://nandland.com/7-segment-display/
-------------------------------------------------------------------------------
-- This file converts a 4 bit binary number into it's hex representation in a 
-- 7-segment display. It can also show special symbols defined in this file
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Binary_To_7Segment is
    port (
        i_Binary_Num        : in std_logic_vector(3 downto 0);
        i_Is_Special_Symbol : in std_logic;
        o_Segment_A         : out std_logic;
        o_Segment_B         : out std_logic;
        o_Segment_C         : out std_logic;
        o_Segment_D         : out std_logic;
        o_Segment_E         : out std_logic;
        o_Segment_F         : out std_logic;
        o_Segment_G         : out std_logic
    );
end entity Binary_To_7Segment;

architecture RTL of Binary_To_7Segment is

    signal r_Full_Input : std_logic_vector(4 downto 0);

    signal r_Hex_Encoding : std_logic_vector(7 downto 0) := (others => '0');

begin

    -- Purpose: Creates a case statement for all possible input binary numbers.
    -- Drives r_Hex_Encoding appropriately for each input combination.
    with r_Full_Input select
        r_Hex_Encoding <=
        -- Hex numbers (i_Is_Special_Symbol = '0')
        X"7E" when "00000", -- 0
        X"30" when "00001", -- 1
        X"6D" when "00010", -- 2
        X"79" when "00011", -- 3
        X"33" when "00100", -- 4
        X"5B" when "00101", -- 5
        X"5F" when "00110", -- 6
        X"70" when "00111", -- 7
        X"7F" when "01000", -- 8
        X"7B" when "01001", -- 9
        X"77" when "01010", -- A
        X"1F" when "01011", -- B
        X"4E" when "01100", -- C
        X"3D" when "01101", -- D
        X"4F" when "01110", -- E
        X"47" when "01111", -- F
        -- Special symbols ((i_Is_Special_Symbol = '1'))
        X"01" when "10000", -- minus sign
        X"00" when "10001", -- all off
        -- default
        X"00" when others; -- all off

    -- Concatenate the inputs
    r_Full_Input <= i_Is_Special_Symbol & i_Binary_Num;

    -- r_Hex_Encoding(7) is unused
    o_Segment_A <= r_Hex_Encoding(6);
    o_Segment_B <= r_Hex_Encoding(5);
    o_Segment_C <= r_Hex_Encoding(4);
    o_Segment_D <= r_Hex_Encoding(3);
    o_Segment_E <= r_Hex_Encoding(2);
    o_Segment_F <= r_Hex_Encoding(1);
    o_Segment_G <= r_Hex_Encoding(0);

end architecture RTL;