library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.float_pkg.all;

library vunit_lib;
context vunit_lib.com_context;
-- use vunit_lib.sync_pkg.all;

use work.tb_sig_gen_pkg.all;

-- set frequency
-- set phase
-- set delay
-- set low level, high level
-- set shape (triangle, rectangle, sine)

entity tb_sig_gen_mod is

  generic (
    inst_name : string := C_DEFAULT_INST_NAME);

  port (
    current_time_i : in time;
    signal_o : out real);

end entity tb_sig_gen_mod;

architecture behav of tb_sig_gen_mod is
  signal shape : sig_gen_shape_t := SIG_SHAPE_NONE;

  signal frequency : real := 0.0;

  signal min_level : real := -1.0;
  signal max_level : real := 1.0;

  signal delay : time := 0 ns;

  signal phase : real := 0.0;

  function to_seconds_real (
    t : time)
    return real is
  begin
    return real(t / 1 ns) / 1_000_000_000.0;
  end function to_seconds_real;

  function get_period (
    frequency : real)
    return real is
  begin  -- function get_period
    if frequency = 0.0 then
      return 0.0; -- should be inifity
    end if;

    return 1.0 / frequency;
  end function get_period;

  function get_triangle_value (
    t   : time;
    frequency: real;
    min : real;
    max: real;
    delay: time)
    return real is
    constant period : real := get_period(frequency);
    constant position : real := to_seconds_real(t - delay) mod period / period;
  begin
    if position < 0.5 then
      -- go up
      return 2.0 * position * (max - min) + min;
    else
      -- go down
      return 2.0 * (position - 0.5) * (min - max) + max;
    end if;
  end function get_triangle_value;

  function get_rectangle_value (
    t : time;
    frequency: real;
    min : real;
    max: real;
    delay: time)
    return real is
    constant period : real := get_period(frequency);
    constant position : real := to_seconds_real(t - delay) mod period;
  begin
    if position < period / 2.0 then
      return max;
    else
      return min;
    end if;
  end function get_rectangle_value;

  function get_sine_value (
    t   : time;
    frequency: real;
    min : real;
    max: real;
    delay: time;
    phase: real)
    return real is
  begin
    return SIN(2.0 * MATH_PI * frequency * (to_seconds_real(t - delay)) + phase);
  end function get_sine_value;

begin  -- architecture behav

  signal_gen: process (all) is
    variable sig : real := 0.0;
  begin  -- process signal_gen
    case shape is
      when SIG_SHAPE_NONE => sig := 0.0;
      when SIG_SHAPE_TRIANGLE => sig := get_triangle_value(current_time_i, frequency => frequency, min => min_level, max => max_level, delay => delay);
      when SIG_SHAPE_RECTANGLE => sig := get_rectangle_value(current_time_i, frequency => frequency, min => min_level, max => max_level, delay => delay);
      when SIG_SHAPE_SINE => sig := get_sine_value(current_time_i, frequency => frequency, min => min_level, max => max_level, delay => delay, phase => phase);
      when others => report "Unknown signal shape" severity failure;
    end case;

    signal_o <= sig;
  end process signal_gen;

  message_handler: process is
    constant self : actor_t := new_actor(inst_name);

    variable request_msg : msg_t;
    variable msg_type : msg_type_t;

    variable request_frequency : real;
    variable request_min_level : real;
    variable request_max_level : real;
    variable request_delay : time;
    variable request_phase : real;
    variable request_shape : integer;
  begin  -- process command_bus
    receive(net, self, request_msg);
    msg_type := message_type(request_msg);

    if msg_type = set_frequency_msg then
      request_frequency := pop(request_msg);
      frequency <= request_frequency;
    elsif msg_type = set_min_level_msg then
      request_min_level := pop(request_msg);
      min_level <= request_min_level;
    elsif msg_type = set_max_level_msg then
      request_max_level := pop(request_msg);
      max_level <= request_max_level;
    elsif msg_type = set_delay_msg then
      request_delay := pop(request_msg);
      delay <= request_delay;
    elsif msg_type = set_phase_msg then
      request_phase := pop(request_msg);
      phase <= request_phase;
    elsif msg_type = set_shape_msg then
      request_shape := pop(request_msg);
      shape <= sig_gen_shape_t'val(request_shape);
    else
      unexpected_msg_type(msg_type);
    end if;

  end process message_handler;

end architecture behav;
