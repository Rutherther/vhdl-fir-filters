library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.com_context;

use work.tb_sig_adder_pkg;
use work.tb_sig_gen_pkg;
use work.tb_adc_pkg;

library filter;

entity test is

  generic (
    runner_cfg : string);

end entity test;

architecture tb of test is
  constant frequency : real := 1_000_000.0;
  constant resolution : natural := 12;

  signal current_time : time;

  signal sig, reconstructed_sig : real;
  signal sampled_sig  : std_logic_vector(resolution - 1 downto 0);
  signal filtered_sig : std_logic_vector(resolution - 1 downto 0);

  signal clk : std_logic;
  signal rst_n : std_logic := '0';
begin  -- architecture tb

  main: process is
    variable generator : actor_t;
  begin  -- process main
    test_runner_setup(runner, runner_cfg);

    wait until rst_n = '1';
    wait until clk = '0';

    while test_suite loop
      if run("test") then
        tb_sig_adder_pkg.push_gen(net, generator);
        tb_sig_gen_pkg.set_frequency(net, 1000.0, actor => generator);
        tb_sig_gen_pkg.set_shape(net, tb_sig_gen_pkg.SIG_SHAPE_SINE, actor => generator);

        tb_sig_adder_pkg.push_gen(net, generator);
        tb_sig_gen_pkg.set_frequency(net, 2000.0, actor => generator);
        tb_sig_gen_pkg.set_shape(net, tb_sig_gen_pkg.SIG_SHAPE_SINE, actor => generator);

        tb_adc_pkg.set_min_max(net, -2.0, 2.0);
        tb_adc_pkg.set_sampling_rate(net, frequency);
        tb_adc_pkg.run(net);

        wait for 100 ms;
      end if;
    end loop;

    test_runner_cleanup(runner);
  end process main;

  rst_n <= '1' after 10 us;

  dut: entity filter.filter
    generic map (
      RESOLUTION => resolution)
    port map (
      clk_i    => clk,
      rst_in   => rst_n,
      signal_i => sampled_sig,
      signal_o => filtered_sig);

  adder: entity work.tb_sig_adder_mod
    generic map (
      MAX_GENERATORS => 5)
    port map (
      current_time_i => current_time,
      signal_o       => sig);

  adc: entity work.tb_adc_mod
    generic map (
      RESOLUTION => resolution)
    port map (
      clk_i          => clk,
      signal_i       => sig,
      signal_o       => sampled_sig,
      current_time_o => current_time);

  xtal: entity work.tb_xtal_mod
    generic map (
      default_frequency => frequency)
    port map (
      clk_o => clk);

end architecture tb;
