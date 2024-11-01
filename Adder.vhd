LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

-- Carry_In == 1:
-- A | B || S | C_out 
-- 0 | 0 || 1 |  0
-- 0 | 1 || 0 |  1
-- 1 | 0 || 0 |  1
-- 1 | 1 || 1 |  1
-- S == XNOR   C_out == OR

-- Carry_In == 0:
-- A | B || S | C_out 
-- 0 | 0 || 0 |  0
-- 0 | 1 || 1 |  0
-- 1 | 0 || 1 |  0
-- 1 | 1 || 0 |  1
-- S == XOR   C_out == AND

ENTITY Adder IS

    PORT (
        i_Data_0 : IN STD_LOGIC;
        i_Data_1 : IN STD_LOGIC;
        i_Carry_In : IN STD_LOGIC;
        o_Result : OUT STD_LOGIC;
        o_Carry_Out : OUT STD_LOGIC;
    );

END ENTITY Adder;

ARCHITECTURE RTL OF Adder IS
BEGIN
    o_Result <= (i_Data_0 XNOR i_Data_1) WHEN i_Carry_In = '1' ELSE
        (i_Data_0 XOR i_Data_1);

    o_Carry_Out <= (i_Data_0 OR i_Data_1) WHEN i_Carry_In = '1' ELSE
        (i_Data_0 AND i_Data_1);
END ARCHITECTURE RTL;