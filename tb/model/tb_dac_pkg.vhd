library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.com_context;

package tb_dac_pkg is

  constant C_DEFAULT_INST_NAME : string := "dac_mod";

  constant set_min_max_msg : msg_type_t := new_msg_type("dac set min max");

  impure function get_actor (
    constant inst_name : string := C_DEFAULT_INST_NAME)
    return actor_t;

  procedure set_min_max (
    signal net : inout network_t;
    constant min : in real;
    constant max : in real;
    constant actor : in actor_t := get_actor);

end package tb_dac_pkg;

package body tb_dac_pkg is

  impure function get_actor (
    constant inst_name : string := C_DEFAULT_INST_NAME)
    return actor_t is
  begin
    return find(inst_name);
  end function get_actor;

  procedure set_min_max (
    signal net     : inout network_t;
    constant min   : in    real;
    constant max   : in    real;
    constant actor : in    actor_t := get_actor) is
    variable msg : msg_t := new_msg(set_min_max_msg);
  begin
    push(msg, min);
    push(msg, max);
    send(net, actor, msg);
  end procedure set_min_max;

end package body tb_dac_pkg;
