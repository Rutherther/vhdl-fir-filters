library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.com_context;
-- use vunit_lib.sync_pkg.all;

package tb_xtal_pkg is
  constant enable_msg : msg_type_t := new_msg_type("xtal enable");
  constant disable_msg : msg_type_t := new_msg_type("xtal disable");
  constant set_frequency_msg : msg_type_t := new_msg_type("xtal set frequency");

  constant C_DEFAULT_INST_NAME : string := "xtal_mod";

  procedure enable (
    signal net         : inout network_t;
    constant inst_name : in    string := C_DEFAULT_INST_NAME);

  procedure disable (
    signal net         : inout network_t;
    constant inst_name : in    string := C_DEFAULT_INST_NAME);

  procedure set_frequency (
    signal net         : inout network_t;
    constant frequency : in    real;
    constant inst_name : in    string := C_DEFAULT_INST_NAME);

  impure function get_actor (
    constant inst_name : in    string := C_DEFAULT_INST_NAME) return actor_t;

end package tb_xtal_pkg;

package body tb_xtal_pkg is
  impure function get_actor (
    constant inst_name : in    string := C_DEFAULT_INST_NAME) return actor_t is
  begin
    return find(inst_name);
  end function get_actor;

  procedure enable (
    signal net         : inout network_t;
    constant inst_name : in    string := C_DEFAULT_INST_NAME) is
    constant actor : actor_t := get_actor(inst_name);
    variable msg : msg_t := new_msg(enable_msg);
  begin
    send(net, actor, msg);
  end procedure enable;

  procedure disable (
    signal net         : inout network_t;
    constant inst_name : in    string := C_DEFAULT_INST_NAME) is
    constant actor : actor_t := get_actor(inst_name);
    variable msg : msg_t := new_msg(disable_msg);
  begin
    send(net, actor, msg);
  end procedure disable;

  procedure set_frequency (
    signal net         : inout network_t;
    constant frequency : in    real;
    constant inst_name : in    string := C_DEFAULT_INST_NAME) is
    constant actor : actor_t := get_actor(inst_name);
    variable msg : msg_t := new_msg(set_frequency_msg);
  begin
    push(msg, frequency);
    send(net, actor, msg);
  end procedure set_frequency;

end package body tb_xtal_pkg;
