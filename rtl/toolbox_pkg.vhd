--------------------------------------------------------------------------------
--! Project  : crus.util.toolbox
--! Engineer : Chase Ruskin
--! Course   : Digital Design - EEL4712C
--! Created  : October 17, 2021
--! Package  : toolbox_pkg
--! Details  :
--!     Helper functions for file I/O, reporting, and casting.
--!
--!     NAME            PARAMETERS         RETURN VALUE
--!     to_sl           (integer)          -> std_logic
--!     log_slv         (std_logic_vector) -> string
--!     log_sl          (std_logic)        -> string
--!     read_int_to_slv (text, positive)   -> std_logic_vector
--!     read_int_to_sl  (text)             -> std_logic
--!     read_str_to_slv (text, positive)   -> std_logic_vector
--!     read_str_to_sl  (text)             -> std_logic
--!     char_to_sl      (character)        -> std_logic
--!     assert_eq_slv   (severity_level, std_logic_vector, std_logic_vector, string)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package toolbox_pkg is
    --! Casts an integer to single logic bit. Any value other than 0 maps to
    --! a logical '1'.
    function to_sl(i: integer) return std_logic;

    --! Returns a string representation of logic vector to output to console.
    function log_slv(slv: std_logic_vector) return string;

    --! Returns a string representation of logic bit to output to console.
    function log_sl(sl: std_logic) return string;

    --! Consumes a single line in file `f` to cast from numerical value to a 
    --! logic vector of size `len` consisting of logical '1' and '0's.
    --!
    --! Note: Integers cannot be read as 'negative' with a leading '-' sign.
    impure function read_int_to_slv(file f: text; len: positive) return std_logic_vector;

    --! Consumes a single line in file `f` to cast from numerical value to logical
    --! '1' or '0'.
    impure function read_int_to_sl(file f: text) return std_logic;

    --! Consumes a single line in file `f` to be a logic vector of size `len`
    --! consisting of logical '1' and '0's.
    impure function read_str_to_slv(file f: text; len: positive) return std_logic_vector;

    --! Consumes a single line in file `f` to be a logical '1' or '0'.
    impure function read_str_to_sl(file f: text) return std_logic;

    --! Casts a character `c` to a logical '1' or '0'. Anything not the character
    --! '1' maps to a logical '0'.
    function char_to_sl(c: character) return std_logic;

    --! Reports a mismatch between logic vectors.
    function error_slv(id: string; rec: std_logic_vector; expect: std_logic_vector) return string;

    --! Reports a mismatch between logic bits.
    function error_sl(id: string; rec: std_logic; expect: std_logic) return string;

    --! Asserts `rec` == `expect` and logs error message if the assertion is false.
    procedure assert_eq_slv(lvl: severity_level; rec: std_logic_vector; expect: std_logic_vector; message: string);

end package toolbox_pkg;


package body toolbox_pkg is

    procedure assert_eq_slv(lvl: severity_level; rec: std_logic_vector; expect: std_logic_vector; message: string) is
    begin
        assert rec = expect report error_slv(message, rec, expect) severity lvl;
    end procedure;


    function error_slv(id: string; rec: std_logic_vector; expect: std_logic_vector) return string is
    begin
        return "ERROR: [" & id & "] received " & log_slv(rec) & " - expected " & log_slv(expect);
    end function;


    function error_sl(id: string; rec: std_logic; expect: std_logic) return string is
    begin
        return "ERROR: [" & id & "] received " & log_sl(rec) & " - expected " & log_sl(expect);
    end function;


    function to_sl(i: integer) return std_logic is
    begin
        if(i = 0) then
            return '0';
        else
            return '1';
        end if;
    end function;


    function log_slv(slv: std_logic_vector) return string is
        variable str : string(1 to slv'length);
        variable sl_bit : std_logic;
    begin
        for ii in 1 to slv'length loop
            sl_bit := slv(slv'length-ii);
            if sl_bit = '1' then
                str(ii) := '1';
            elsif sl_bit = '0' then
                str(ii) := '0';
            else
                str(ii) := '?';
            end if;
        end loop;

        return """" & str & """";
    end function;


    function log_sl(sl: std_logic) return string is
    begin
        return std_logic'image(sl);
    end function;


    impure function read_int_to_slv(file f: text; len: positive) return std_logic_vector is
        variable text_line : line;
        variable text_int  : integer;
    begin
        readline(f, text_line);
        read(text_line, text_int);
        return std_logic_vector(to_unsigned(text_int, len));
    end function;


    impure function read_int_to_sl(file f: text) return std_logic is
        variable text_line : line;
        variable text_int  : integer;
    begin
        readline(f, text_line);
        read(text_line, text_int);
        return to_sl(text_int);
    end function;


    function char_to_sl(c: character) return std_logic is
    begin
        if(c = '1') then
            return '1';
        else
            return '0';
        end if;
    end function;


    impure function read_str_to_slv(file f: text; len: positive) return std_logic_vector is
        variable text_line : line;
        variable text_str  : string(len downto 1);
        variable slv       : std_logic_vector(len-1 downto 0);
    begin
        readline(f, text_line);
        read(text_line, text_str);

        for ii in len-1 downto 0 loop
            slv(ii) := char_to_sl(text_str(ii+1));
        end loop;

        return slv;
    end function;


    impure function read_str_to_sl(file f: text) return std_logic is
        variable text_line : line;
        variable text_str  : string(1 downto 1);
    begin
        readline(f, text_line);
        read(text_line, text_str);
        return char_to_sl(text_str(1));
    end function;

end toolbox_pkg;