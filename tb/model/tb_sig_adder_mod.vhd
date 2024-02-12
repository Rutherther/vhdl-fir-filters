library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.com_context;

use work.tb_sig_adder_pkg.all;

entity tb_sig_adder_mod is

  generic (
    inst_name : string := C_DEFAULT_INST_NAME;
    MAX_GENERATORS : natural);

  port (
    current_time_i : in  time;
    signal_o       : out real);

end entity tb_sig_adder_mod;

architecture behav of tb_sig_adder_mod is
  signal active_gen_count : integer range 0 to MAX_GENERATORS := 0;

  type real_arr_t is array (natural range <>) of real;
  signal outputs : real_arr_t(1 to MAX_GENERATORS);
begin  -- architecture behav

  generators: for i in 1 to MAX_GENERATORS generate
    generator: entity work.tb_sig_gen_mod
      generic map (
        inst_name => get_gen_inst_name(i, inst_name))
      port map (
        current_time_i => current_time_i,
        signal_o => outputs(i)
    );
  end generate generators;

  summer: process (all) is
    variable sum : real := 0.0;
  begin  -- process sum_output
    sum := 0.0;
    for i in 1 to active_gen_count loop
      sum := sum + outputs(i);
    end loop;  -- i

    signal_o <= sum;
  end process summer;

  message_handler: process is
    constant actor : actor_t := new_actor(inst_name);
    variable request_msg, reply_msg : msg_t;
    variable msg_type : msg_type_t;
  begin  -- process message_handler
    receive(net, actor, request_msg);
    msg_type := message_type(request_msg);

    -- handle_sync_message(net, msg_type, request_msg);

    if msg_type = push_msg then
      reply_msg := new_msg;
      push(reply_msg, active_gen_count + 1);

      active_gen_count <= active_gen_count + 1;

      reply(net, request_msg, reply_msg);
    elsif msg_type = pop_msg then
      active_gen_count <= active_gen_count - 1;
    elsif msg_type = clear_msg then
      active_gen_count <= 0;
    else
      unexpected_msg_type(msg_type);
    end if;
  end process message_handler;

end architecture behav;
