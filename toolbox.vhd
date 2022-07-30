--------------------------------------------------------------------------------
--! Project: c-rus.util.toolbox
--! Author: Chase Ruskin
--! Course: Digital Design - EEL4712C
--! Created: October 17, 2021
--! Package: toolbox
--! Description:
--!  Helper functions for file I/O, reporting, and casting. Functions include:
--!      to_std_logic(integer) -> std_logic
--!      log_logic_vector(std_logic_vector) -> string
--!      log_logic(std_logic) -> string
--!      read_int_to_logic_vector(text, positive) -> std_logic_vector
--!      read_int_to_logic(text) -> std_logic
--!      read_str_to_logic_vector(text, positive) -> std_logic_vector
--!      read_str_to_logic(text) -> std_logic
--!      char_to_logic(character) -> std_logic
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package toolbox is
    --! Casts an integer to single logic bit. Any value other than 0 maps to
    --! a logical '1'.
    function to_std_logic(
        i : in integer
        )
    return std_logic;

    --! Returns a string representation of logic vector to output to console.
    --! Limited to 32-bit vectors due to using `integer'image`.
    function log_logic_vector(
        slv : in std_logic_vector
    )
    return string;

    --! Returns a string representation of logic bit to output to console.
    function log_logic(
        sl : in std_logic
    )
    return string;

    --! Consumes a single line in file `f` to cast from numerical value to a 
    --! logic vector of size `len` consisting of logical '1' and '0's.
    impure function read_int_to_logic_vector(
        file f : text;
        len : in positive
    )
    return std_logic_vector;

    --! Consumes a single line in file `f` to cast from numerical value to logical
    --! '1' or '0'.
    impure function read_int_to_logic(
        file f : text
    )
    return std_logic;

    --! Consumes a single line in file `f` to be a logic vector of size `len`
    --! consisting of logical '1' and '0's.
    impure function read_str_to_logic_vector(
        file f : text;
        len : positive
    )
    return std_logic_vector;

    --! Consumes a single line in file `f` to be a logical '1' or '0'.
    impure function read_str_to_logic(
        file f : text
    )
    return std_logic;

    --! Casts a character `c` to a logical '1' or '0'. Anything not the character
    --! '1' maps to a logical '0'.
    function char_to_logic(
        c : character
    )
    return std_logic;
end package;

package body toolbox is

    function to_std_logic(
        i : in integer
    )
    return std_logic is
    begin
        if(i = 0) then
            return '0';
        else
            return '1';
        end if;
    end function;


    function log_logic_vector(
        slv : in std_logic_vector
    )
    return string is
    begin
        return integer'image(to_integer(signed(slv)));
    end function;


    function log_logic(
        sl : in std_logic
    )
    return string is
    begin
        return std_logic'image(sl);
    end function;


    impure function read_int_to_logic_vector(
        file f : text;
        len : in positive
    )
    return std_logic_vector is
        variable text_line : line;
        variable text_int  : integer;
    begin
        readline(f,text_line);
        read(text_line,text_int);
        return std_logic_vector(to_unsigned(text_int, len));
    end function;


    impure function read_int_to_logic(
        file f : text
    )
    return std_logic is
        variable text_line : line;
        variable text_int  : integer;
    begin
        readline(f,text_line);
        read(text_line,text_int);
        return to_std_logic(text_int);
    end function;


    function char_to_logic(
        c : character
    )
    return std_logic is
    begin
        if(c = '1') then
            return '1';
        else
            return '0';
        end if;
    end function;


    impure function read_str_to_logic_vector(
        file f : text;
        len : positive
    )
    return std_logic_vector is
        variable text_line : line;
        variable text_str  : string(len downto 1);
        variable slv       : std_logic_vector(len-1 downto 0);
    begin
        readline(f,text_line);
        read(text_line,text_str);

        for ii in len-1 downto 0 loop
            slv(ii) := char_to_logic(text_str(ii+1));
        end loop;

        return slv;
    end function;


    impure function read_str_to_logic(
        file f : text
    )
    return std_logic is
        variable text_line : line;
        variable text_str  : string(1 downto 1);
    begin
        readline(f,text_line);
        read(text_line,text_str);
        return char_to_logic(text_str(1));
    end function;

end toolbox;