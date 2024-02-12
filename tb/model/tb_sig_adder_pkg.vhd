library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.com_context;

use work.tb_sig_gen_pkg;

package tb_sig_adder_pkg is

  constant push_msg : msg_type_t := new_msg_type("adder push");
  constant pop_msg : msg_type_t := new_msg_type("adder pop");
  constant clear_msg : msg_type_t := new_msg_type("adder pop");

  constant C_DEFAULT_INST_NAME : string := "sig_adder_mod";

  impure function get_actor (
    constant inst_name : string := C_DEFAULT_INST_NAME)
    return actor_t;

  procedure push_gen (
    signal net         : inout network_t;
    variable gen_actor : out   actor_t;
    constant inst_name : in    string := C_DEFAULT_INST_NAME);

  procedure pop_gen (
    signal net         : inout network_t;
    constant inst_name : in    string := C_DEFAULT_INST_NAME);

  procedure clear_gens (
    signal net         : inout network_t;
    constant inst_name : in    string := C_DEFAULT_INST_NAME);

  impure function get_gen_actor (
    constant index     : in    natural;
    constant inst_name : in    string := C_DEFAULT_INST_NAME) return actor_t;

  function get_gen_inst_name (
    constant index     : in    natural;
    constant inst_name : in    string := C_DEFAULT_INST_NAME) return string;

end package tb_sig_adder_pkg;

package body tb_sig_adder_pkg is

  impure function get_actor (
    constant inst_name : string := C_DEFAULT_INST_NAME)
    return actor_t is
  begin
    return find(inst_name);
  end function get_actor;

  procedure push_gen (
    signal net         : inout network_t;
    variable gen_actor : out   actor_t;
    constant inst_name : in    string := C_DEFAULT_INST_NAME) is
    constant actor : actor_t := get_actor(inst_name);

    variable msg : msg_t := new_msg(push_msg);
    variable reply_msg : msg_t;
    variable retrieved_index : natural;

  begin
    request(net, actor, msg, reply_msg);

    retrieved_index := pop(reply_msg);
    delete(reply_msg);

    gen_actor := get_gen_actor(retrieved_index, inst_name);

  end procedure push_gen;

  procedure pop_gen (
    signal net         : inout network_t;
    constant inst_name : in    string := C_DEFAULT_INST_NAME) is

    constant actor : actor_t := get_actor(inst_name);
    variable msg : msg_t := new_msg(pop_msg);

  begin
    send(net, actor, msg);
  end procedure pop_gen;

  procedure clear_gens (
    signal net         : inout network_t;
    constant inst_name : in    string := C_DEFAULT_INST_NAME) is

    constant actor : actor_t := get_actor(inst_name);
    variable msg : msg_t := new_msg(clear_msg);

  begin
    send(net, actor, msg);
  end procedure clear_gens;

  impure function get_gen_actor (
    constant index     : in    natural;
    constant inst_name : in    string := C_DEFAULT_INST_NAME) return actor_t is
  begin
    return tb_sig_gen_pkg.get_actor(get_gen_inst_name(index, inst_name));
  end function get_gen_actor;

  function get_gen_inst_name (
    constant index     : in    natural;
    constant inst_name : in    string := C_DEFAULT_INST_NAME) return string is
  begin
    return inst_name & ":generator:" & natural'image(index);
  end function get_gen_inst_name;

end package body tb_sig_adder_pkg;
