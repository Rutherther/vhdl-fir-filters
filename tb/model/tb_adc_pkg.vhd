library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.com_context;
-- use vunit_lib.sync_pkg.all;

package tb_adc_pkg is
  constant set_sampling_rate_msg : msg_type_t := new_msg_type("adc set sampling rate");
  constant set_current_time_msg : msg_type_t := new_msg_type("adc set current time");
  constant set_min_max_msg : msg_type_t := new_msg_type("adc set min max");
  constant run_msg : msg_type_t := new_msg_type("adc run");
  constant pause_msg : msg_type_t := new_msg_type("adc pause");

  constant C_DEFAULT_INST_NAME : string := "adc_mod";

  impure function get_actor (
    constant inst_name : string := C_DEFAULT_INST_NAME)
    return actor_t;

  procedure run (
    signal net : inout network_t;
    constant inst_name : in string := C_DEFAULT_INST_NAME);

  procedure pause (
    signal net : inout network_t;
    constant inst_name : in string := C_DEFAULT_INST_NAME);

  procedure set_current_time (
    signal net : inout network_t;
    constant current_time : in time;
    constant inst_name : in string := C_DEFAULT_INST_NAME);

  procedure set_sampling_rate (
    signal net : inout network_t;
    constant sampling_frequency : in real;
    constant inst_name : in string := C_DEFAULT_INST_NAME);

  procedure set_min_max (
    signal net : inout network_t;
    constant min : in real;
    constant max : in real;
    constant inst_name : in string := C_DEFAULT_INST_NAME);

end package tb_adc_pkg;

package body tb_adc_pkg is

  impure function get_actor (
    constant inst_name : string := C_DEFAULT_INST_NAME)
    return actor_t is
  begin
    return find(inst_name);
  end function get_actor;

  procedure run (
    signal net : inout network_t;
    constant inst_name : in string := C_DEFAULT_INST_NAME) is
    constant actor : actor_t := get_actor(inst_name);
    variable msg : msg_t := new_msg(run_msg);
  begin
    send(net, actor, msg);
  end procedure run;

  procedure pause (
    signal net : inout network_t;
    constant inst_name : in string := C_DEFAULT_INST_NAME) is
    constant actor : actor_t := get_actor(inst_name);
    variable msg : msg_t := new_msg(pause_msg);
  begin
    send(net, actor, msg);
  end procedure pause;

  procedure set_current_time (
    signal net : inout network_t;
    constant current_time : in time;
    constant inst_name : in string := C_DEFAULT_INST_NAME) is
    constant actor : actor_t := get_actor(inst_name);
    variable msg : msg_t := new_msg(set_current_time_msg);
  begin
    push(msg, current_time);
    send(net, actor, msg);
  end procedure set_current_time;

  procedure set_sampling_rate (
    signal net : inout network_t;
    constant sampling_frequency : in real;
    constant inst_name : in string := C_DEFAULT_INST_NAME) is
    constant actor : actor_t := get_actor(inst_name);
    variable msg : msg_t := new_msg(set_sampling_rate_msg);
  begin
    push(msg, sampling_frequency);
    send(net, actor, msg);
  end procedure set_sampling_rate;

  procedure set_min_max (
    signal net : inout network_t;
    constant min : in real;
    constant max : in real;
    constant inst_name : in string := C_DEFAULT_INST_NAME) is
    constant actor : actor_t := get_actor(inst_name);
    variable msg : msg_t := new_msg(set_min_max_msg);
  begin
    push(msg, min);
    push(msg, max);
    send(net, actor, msg);
  end procedure set_min_max;

end package body tb_adc_pkg;
