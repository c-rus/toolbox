library ieee;
use ieee.std_logic_1164.all;

entity toolbox_test is 
    port(
        data: out std_logic
    );
end entity;

architecture rtl of toolbox_test is
begin
    data <= '1';
end architecture rtl;


library work;
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity toolbox_tb is
end entity;

architecture sim of toolbox_tb is
    constant WIDTH_A : positive := 12;

    --! internal test signals
    signal slv0 : std_logic_vector(WIDTH_A-1 downto 0) := (others => '0');
    signal slv1 : std_logic_vector(WIDTH_A-1 downto 0) := (others => '0');
    signal slv2 : std_logic_vector(7 downto 0);

    signal sl0 : std_logic;


    signal w_data : std_logic;
begin
    -- unit-under-test
    uut: entity work.toolbox_test 
    port map(
        data => w_data
    );

    --! test reading a file filled with test vectors
    io: process
        file numbers: text open read_mode is "../sim/numbers.dat";
    begin
        -- read 1s and 0s into logic vectors
        slv0 <= work.toolbox.read_str_to_logic_vector(numbers, WIDTH_A);
        slv1 <= work.toolbox.read_str_to_logic_vector(numbers, WIDTH_A);
        wait for 10 ns;
        report "slv0: " & work.toolbox.log_logic_vector(slv0);
        report "slv1: " & work.toolbox.log_logic_vector(slv1);

        assert slv0 = slv1 report work.toolbox.error_slv("slv0", slv0, slv1) severity note;

        -- read integers into logic vectors
        slv0 <= work.toolbox.read_int_to_logic_vector(numbers, WIDTH_A);
        slv2 <= work.toolbox.read_int_to_logic_vector(numbers, 8);
        wait for 10 ns;
        report "slv0: " & work.toolbox.log_logic_vector(slv0);
        report "slv2: " & work.toolbox.log_logic_vector(slv1);

        -- read characters into logic bits
        sl0 <= work.toolbox.read_str_to_logic(numbers);
        wait for 10 ns;
        report "sl0: " & work.toolbox.log_logic(sl0);

        sl0 <= work.toolbox.read_str_to_logic(numbers);
        wait for 10 ns;
        report "sl0: " & work.toolbox.log_logic(sl0);

        assert w_data /= sl0 report work.toolbox.error_sl("data", w_data, sl0) severity note;
        wait;
    end process;

end architecture sim;
