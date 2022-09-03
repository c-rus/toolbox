--------------------------------------------------------------------------------
--! Project   : crus.util.toolbox
--! Engineer  : Chase Ruskin
--! Course    : Digital Design - EEL4712C
--! Created   : October 17, 2021
--! Testbench : toolbox_tb
--! Details   :
--!     Tests the toolbox_pkg package by using a test entity and utilizing the
--!     function calls on an sample input test vector file 'numbers.dat'.
--------------------------------------------------------------------------------
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
use work.toolbox_pkg;

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
        file numbers: text open read_mode is "../../sim/numbers.dat";
    begin
        -- read 1s and 0s into logic vectors
        slv0 <= toolbox_pkg.read_str_to_logic_vector(numbers, WIDTH_A);
        slv1 <= toolbox_pkg.read_str_to_logic_vector(numbers, WIDTH_A);
        wait for 10 ns;
        report "slv0: " & toolbox_pkg.log_logic_vector(slv0);
        report "slv1: " & toolbox_pkg.log_logic_vector(slv1);

        assert slv0 = slv1 report toolbox_pkg.error_slv("slv0", slv0, slv1) severity note;

        -- read integers into logic vectors
        slv0 <= toolbox_pkg.read_int_to_logic_vector(numbers, WIDTH_A);
        slv2 <= toolbox_pkg.read_int_to_logic_vector(numbers, 8);
        wait for 10 ns;
        report "slv0: " & toolbox_pkg.log_logic_vector(slv0);
        report "slv2: " & toolbox_pkg.log_logic_vector(slv1);

        -- read characters into logic bits
        sl0 <= toolbox_pkg.read_str_to_logic(numbers);
        wait for 10 ns;
        report "sl0: " & toolbox_pkg.log_logic(sl0);

        sl0 <= toolbox_pkg.read_str_to_logic(numbers);
        wait for 10 ns;
        report "sl0: " & toolbox_pkg.log_logic(sl0);

        assert w_data /= sl0 report toolbox_pkg.error_sl("data", w_data, sl0) severity note;
        wait;
    end process;

end architecture sim;
