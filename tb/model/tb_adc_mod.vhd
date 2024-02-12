library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

use work.tb_adc_pkg.all;

library vunit_lib;
context vunit_lib.com_context;
context vunit_lib.vunit_context;
-- use vunit_lib.sync_pkg.all;

-- set sampling period
-- set current time
-- run, pause

entity tb_adc_mod is
  generic (
    inst_name : string := C_DEFAULT_INST_NAME;
    RESOLUTION : natural);

  port (
    clk_i          : in  std_logic;
    signal_i       : in  real;
    signal_o       : out std_logic_vector(RESOLUTION - 1 downto 0);
    clamped_o      : out std_logic;
    current_time_o : out time);

end entity tb_adc_mod;

architecture behav of tb_adc_mod is

  signal current_time       : time := 0 ns;

  signal sampling_frequency : real := 0.0;
  signal running            : std_logic := '0';

  signal max : real := 1.0;
  signal min : real := -1.0;

  signal set_time_to : time;
  signal set_time_request : event_t := new_event("set_time_request");
begin  -- architecture behav
  current_time_o <= current_time;

  set_output_time: process is
  begin  -- process set_output_time
    wait until rising_edge(clk_i) or is_active(set_time_request);

    if is_active_msg(set_time_request) then
      current_time <= set_time_to;
    elsif running = '1' then
      current_time <= current_time + (1_000_000_000.0 / sampling_frequency) * 1 ns;
    end if;
  end process set_output_time;

  sample: process (clk_i) is
  begin  -- process sample
    if rising_edge(clk_i) then          -- rising clock edge
      if signal_i < min then
        signal_o <= (others => '0');
        clamped_o <= '1';
      elsif signal_i > max then
        signal_o <= (others => '1');
        clamped_o <= '1';
      else
        signal_o <= std_logic_vector(to_unsigned(integer((signal_i - min) / (max - min) * (real(2 ** RESOLUTION) - 1.0)), RESOLUTION));
        clamped_o <= '0';
      end if;
    end if;
  end process sample;

  message_handler: process is
    constant actor : actor_t := new_actor(inst_name);
    variable request_msg : msg_t;
    variable msg_type : msg_type_t;
  begin  -- process message_handler
    receive(net, actor, request_msg);
    msg_type := message_type(request_msg);

    -- handle_sync_message(net, msg_type, request_msg);

    if msg_type = set_sampling_rate_msg then
      sampling_frequency <= pop(request_msg);
    elsif msg_type = set_current_time_msg then
      set_time_to <= pop(request_msg);
      notify(set_time_request);
    elsif msg_type = set_min_max_msg then
      min <= pop(request_msg);
      max <= pop(request_msg);
    elsif msg_type = run_msg then
      running <= '1';
    elsif msg_type = pause_msg then
      running <= '0';
    else
      unexpected_msg_type(msg_type);
    end if;
  end process message_handler;

end architecture behav;
