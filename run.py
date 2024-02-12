#!/usr/bin/env python3

from vunit import VUnit
from pathlib import Path

vu = VUnit.from_argv(compile_builtins = False)

vu.add_vhdl_builtins()
vu.add_com()

filter_tb_lib = vu.add_library('filter_tb')
filter_tb_lib.add_source_files(Path(__file__).parent / 'tb/**/*.vhd')

filter_lib = vu.add_library('filter')
filter_lib.add_source_files(Path(__file__).parent / 'src/**/*.vhd')

vu.main()
