library ieee;
use ieee.std_logic_1164.all;

entity filter is
  generic (
    RESOLUTION : natural);

  port (
    clk_i    : in std_logic;
    rst_in   : in std_logic;
    signal_i : in std_logic_vector(RESOLUTION - 1 downto 0);
    signal_o : out std_logic_vector(RESOLUTION - 1 downto 0));

end entity filter;

architecture a1 of filter is

begin  -- architecture a1

  signal_o <= signal_i;

end architecture a1;
