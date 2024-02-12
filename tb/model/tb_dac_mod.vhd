library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.com_context;

use work.tb_dac_pkg.all;

entity tb_dac_mod is

  generic (
    inst_name : string := C_DEFAULT_INST_NAME;
    resolution : natural);

  port (
    clk_i    : in  std_logic;
    signal_i : in  std_logic_vector(resolution - 1 downto 0);
    signal_o : out real);

end entity tb_dac_mod;

architecture behav of tb_dac_mod is
  signal min : real := -1.0;
  signal max : real := 1.0;

  signal reconstructed : real := 0.0;
begin  -- architecture behav
  signal_o <= reconstructed;

  sample: process (clk_i) is
  begin  -- process out
    if rising_edge(clk_i) then          -- rising clock edge
      reconstructed <= real(to_integer(unsigned(signal_i))) / real(2 ** RESOLUTION - 1) * (max - min) + min;
    end if;
  end process sample;

  message_handler: process is
    constant actor : actor_t := new_actor(inst_name);
    variable request_msg : msg_t;
    variable msg_type : msg_type_t;
  begin  -- process message_handler
    receive(net, actor, request_msg);
    msg_type := message_type(request_msg);

    if msg_type = set_min_max_msg then
      min <= pop(request_msg);
      max <= pop(request_msg);
    else
      unexpected_msg_type(msg_type);
    end if;
  end process message_handler;

end architecture behav;
