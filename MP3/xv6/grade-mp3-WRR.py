#!/usr/bin/env python3

import re
from gradelib import *

import os

os.system("make -s --no-print-directory clean")
r = Runner(save("xv6.out"))

@test(2, "task1")
def test_uthread():
    r.run_qemu(shell_script([
        'task1'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_WRR"])
    expected = """dispatch thread#1 at 0: allocated_time=2
dispatch thread#1 at 2: allocated_time=1
thread#1 finish at 3"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(2, "task2")
def test_uthread():
    r.run_qemu(shell_script([
        'task2'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_WRR"])
    expected = """dispatch thread#1 at 0: allocated_time=4
dispatch thread#2 at 4: allocated_time=2
dispatch thread#1 at 6: allocated_time=3
thread#1 finish at 9
dispatch thread#2 at 9: allocated_time=2
dispatch thread#2 at 11: allocated_time=1
thread#2 finish at 12"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(2, "task3")
def test_uthread():
    r.run_qemu(shell_script([
        'task3'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_WRR"])
    expected = """dispatch thread#2 at 0: allocated_time=4
dispatch thread#1 at 4: allocated_time=2
dispatch thread#3 at 6: allocated_time=2
dispatch thread#2 at 8: allocated_time=3
thread#2 finish at 11
dispatch thread#1 at 11: allocated_time=2
dispatch thread#3 at 13: allocated_time=2
dispatch thread#1 at 15: allocated_time=1
thread#1 finish at 16
dispatch thread#3 at 16: allocated_time=1
thread#3 finish at 17"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(2, "task4")
def test_uthread():
    r.run_qemu(shell_script([
        'task4'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_WRR"])
    expected = """dispatch thread#4 at 0: allocated_time=4
thread#4 finish at 4
dispatch thread#1 at 4: allocated_time=1
thread#1 finish at 5
dispatch thread#2 at 5: allocated_time=2
thread#2 finish at 7
dispatch thread#3 at 7: allocated_time=3
thread#3 finish at 10"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

run_tests()
os.system("make -s --no-print-directory clean")
