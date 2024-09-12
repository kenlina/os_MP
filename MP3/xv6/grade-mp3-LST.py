#!/usr/bin/env python3

import re
from gradelib import *

import os

os.system("make -s --no-print-directory clean")
r = Runner(save("xv6.out"))

@test(3, "rttask1")
def test_uthread():
    r.run_qemu(shell_script([
        'rttask1'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_LST"])
    expected = """dispatch thread#1 at 0: allocated_time=3
thread#1 finish one cycle at 3: 2 cycles left
run_queue is empty, sleep for 2 ticks
dispatch thread#1 at 5: allocated_time=3
thread#1 finish one cycle at 8: 1 cycles left
run_queue is empty, sleep for 2 ticks
dispatch thread#1 at 10: allocated_time=3
thread#1 finish one cycle at 13: 0 cycles left"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(3, "rttask2")
def test_uthread():
    r.run_qemu(shell_script([
        'rttask2'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_LST"])
    expected = """dispatch thread#2 at 0: allocated_time=5
thread#2 finish one cycle at 5: 1 cycles left
dispatch thread#1 at 5: allocated_time=7
thread#1 finish one cycle at 12: 1 cycles left
dispatch thread#2 at 12: allocated_time=5
thread#2 finish one cycle at 17: 0 cycles left
dispatch thread#1 at 17: allocated_time=7
thread#1 finish one cycle at 24: 0 cycles left"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(3, "rttask3")
def test_uthread():
    r.run_qemu(shell_script([
        'rttask3'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_LST"])
    expected = """dispatch thread#2 at 0: allocated_time=1
dispatch thread#3 at 1: allocated_time=1
dispatch thread#1 at 2: allocated_time=3
thread#1 finish one cycle at 5: 1 cycles left
dispatch thread#3 at 5: allocated_time=2
thread#3 finish one cycle at 7: 1 cycles left
dispatch thread#2 at 7: allocated_time=4
thread#2 finish one cycle at 11: 1 cycles left
dispatch thread#3 at 11: allocated_time=3
thread#3 finish one cycle at 14: 0 cycles left
dispatch thread#1 at 14: allocated_time=3
thread#1 finish one cycle at 17: 0 cycles left
dispatch thread#2 at 17: allocated_time=5
thread#2 finish one cycle at 22: 0 cycles left"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(3, "rttask4")
def test_uthread():
    r.run_qemu(shell_script([
        'rttask4'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_LST"])
    expected = """dispatch thread#4 at 0: allocated_time=4
thread#4 finish one cycle at 4: 1 cycles left
dispatch thread#3 at 4: allocated_time=3
thread#3 finish one cycle at 7: 1 cycles left
dispatch thread#2 at 7: allocated_time=2
thread#2 finish one cycle at 9: 1 cycles left
dispatch thread#1 at 9: allocated_time=1
thread#1 finish one cycle at 10: 1 cycles left
dispatch thread#4 at 10: allocated_time=4
thread#4 finish one cycle at 14: 0 cycles left
dispatch thread#3 at 14: allocated_time=3
thread#3 finish one cycle at 17: 0 cycles left
dispatch thread#2 at 17: allocated_time=2
thread#2 finish one cycle at 19: 0 cycles left
dispatch thread#1 at 19: allocated_time=1
thread#1 finish one cycle at 20: 0 cycles left"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

run_tests()
os.system("make -s --no-print-directory clean")
