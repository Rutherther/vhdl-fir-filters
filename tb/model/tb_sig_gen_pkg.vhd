library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.com_context;

package tb_sig_gen_pkg is
  constant set_frequency_msg : msg_type_t := new_msg_type("gen set frequency");
  constant set_min_level_msg : msg_type_t := new_msg_type("gen set min level");
  constant set_max_level_msg : msg_type_t := new_msg_type("gen set max level");
  constant set_delay_msg : msg_type_t := new_msg_type("gen set delay");
  constant set_phase_msg : msg_type_t := new_msg_type("gen set phase");
  constant set_shape_msg : msg_type_t := new_msg_type("gen set shape");

  constant C_DEFAULT_INST_NAME : string := "sig_gen_mod";

  type sig_gen_shape_t is (
    SIG_SHAPE_NONE,
    SIG_SHAPE_TRIANGLE,
    SIG_SHAPE_RECTANGLE,
    SIG_SHAPE_SINE
  );

  impure function get_actor (
    constant inst_name : in string := C_DEFAULT_INST_NAME) return actor_t;

  procedure set_frequency (
    signal net         : inout network_t;
    constant frequency : in    real;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME));

  procedure set_min_level (
    signal net         : inout network_t;
    constant min_level : in    real;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME));

  procedure set_max_level (
    signal net         : inout network_t;
    constant max_level : in    real;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME));

  procedure set_delay (
    signal net     : inout network_t;
    constant delay : in    time;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME));

  procedure set_phase (
    signal net     : inout network_t;
    constant phase : in    real;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME));

  procedure set_shape (
    signal net     : inout network_t;
    constant shape : in    sig_gen_shape_t;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME));

end package tb_sig_gen_pkg;

package body tb_sig_gen_pkg is

  impure function get_actor (
    constant inst_name : in string := C_DEFAULT_INST_NAME) return actor_t is
  begin
    return find(inst_name);
  end function get_actor;

  procedure set_frequency (
    signal net         : inout network_t;
    constant frequency : in    real;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME)) is

    variable msg : msg_t := new_msg(set_frequency_msg);

  begin
    push(msg, frequency);
    send(net, actor, msg);
  end procedure set_frequency;

  procedure set_min_level (
    signal net         : inout network_t;
    constant min_level : in    real;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME)) is

    variable msg : msg_t := new_msg(set_min_level_msg);

  begin
    push(msg, min_level);
    send(net, actor, msg);
  end procedure set_min_level;

  procedure set_max_level (
    signal net         : inout network_t;
    constant max_level : in    real;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME)) is

    variable msg : msg_t := new_msg(set_max_level_msg);

  begin
    push(msg, max_level);
    send(net, actor, msg);
  end procedure set_max_level;

  procedure set_delay (
    signal net     : inout network_t;
    constant delay : in    time;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME)) is

    variable msg : msg_t := new_msg(set_delay_msg);

  begin
    push(msg, delay);
    send(net, actor, msg);
  end procedure set_delay;

  procedure set_phase (
    signal net     : inout network_t;
    constant phase : in    real;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME)) is

    variable msg : msg_t := new_msg(set_phase_msg);

  begin
    push(msg, phase);
    send(net, actor, msg);
  end procedure set_phase;

  procedure set_shape (
    signal net     : inout network_t;
    constant shape : in    sig_gen_shape_t;
    constant actor : in actor_t := get_actor(C_DEFAULT_INST_NAME)) is

    variable msg : msg_t := new_msg(set_shape_msg);

  begin

    push(msg, sig_gen_shape_t'pos(shape));
    send(net, actor, msg);
  end procedure set_shape;


end package body tb_sig_gen_pkg;
