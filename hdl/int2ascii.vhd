LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

-- Infos zum Algorithmus
-- http://www.johnloomis.org/ece314/notes/devices/binary_to_BCD/bin_to_bcd.html

ENTITY int2ascii IS
    Port ( i_number : IN  integer RANGE 0 TO 59;
           o_ascii0   : OUT std_logic_vector(7 downto 0);
           o_ascii1   : OUT std_logic_vector(7 downto 0));
END ENTITY int2ascii;

ARCHITECTURE behavioral OF int2ascii IS
    SIGNAL s_bcd0 : unsigned(3 DOWNTO 0);
    SIGNAL s_bcd1 : unsigned(3 DOWNTO 0);
BEGIN
    PROCESS (i_number)
        VARIABLE v_bcd0   : unsigned(3 DOWNTO 0);
        VARIABLE v_bcd1   : unsigned(3 DOWNTO 0);
        VARIABLE v_number : unsigned(7 DOWNTO 0);
    BEGIN
        v_bcd0 := "0000";
        v_bcd1 := "0000";
        v_number := to_unsigned(i_number, v_number'length);

        -- Je BCD Zahl (59 = 2x ist für diese Anwendung ausreichend)
        FOR i IN 1 TO v_number'length LOOP
        
            -- BCD0 > 0100, addiere 0011
            IF v_bcd0 > "0100" THEN
                v_bcd0 := v_bcd0 + "0011";
            END IF;
            
            -- BCD1 > 0100, addiere 0011
            IF v_bcd1 > "0100" THEN
                v_bcd1 := v_bcd1 + "0011";
            END IF;
            
            -- Shift um ein Bit
            v_bcd1 := shift_left(v_bcd1, 1);
            v_bcd1(0) := v_bcd0(3);
            
            v_bcd0 := shift_left(v_bcd0, 1);
            v_bcd0(0) := v_number(v_number'length - i);

        END LOOP;

        -- BCD Zahlen dem entsprechenden Signal zuweisen
        s_bcd0 <= v_bcd0;
        s_bcd1 <= v_bcd1;
    END PROCESS;
    -- Die Umwandlung von BCD in ASCII erfolgt durch jeweiliges vorranstellen einer 0011,
    -- da die ASCII Ziffern 0-9 auf den Zahlen 30-39 liegen.
    o_ascii0 <= std_logic_vector("0011"&s_bcd0);
    o_ascii1 <= std_logic_vector("0011"&s_bcd1);
END ARCHITECTURE behavioral;
