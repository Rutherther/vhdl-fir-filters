library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.com_context;

use work.tb_xtal_pkg.all;

entity tb_xtal_mod is

  generic (
    default_frequency : real;
    inst_name         : string := C_DEFAULT_INST_NAME);

  port (
    clk_o : out std_logic);

end entity tb_xtal_mod;

architecture behav of tb_xtal_mod is
  function get_period (
    constant frequency : real)
    return time is
  begin  -- function get_period
    return (1_000_000_000.0 / frequency) * 1 ns;
  end function get_period;

  signal frequency : real := default_frequency;
  signal enabled : std_logic := '1';
begin  -- architecture behav

  set_clk: process is
    variable curr_period : time;
  begin  -- process set_clk
    curr_period := get_period(frequency);

    if enabled = '0' then
      wait until enabled = '1';
    end if;

    wait for curr_period / 2;
    clk_o <= '1';
    wait for curr_period / 2;
    clk_o <= '0';
  end process set_clk;

  message_handler: process is
    constant actor : actor_t := new_actor(inst_name);

    variable request_msg : msg_t;
    variable msg_type : msg_type_t;
  begin  -- process message_handler
    receive(net, actor, request_msg);
    msg_type := message_type(request_msg);

    if msg_type = enable_msg then
      enabled <= '1';
    elsif msg_type = disable_msg then
      enabled <= '0';
    elsif msg_type = set_frequency_msg then
      frequency <= pop(request_msg);
    else
      unexpected_msg_type(msg_type);
    end if;
  end process message_handler;

end architecture behav;
