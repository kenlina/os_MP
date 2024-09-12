#!/usr/bin/env python3

import os

total_score = 0
max_score = 0

def test(part: int, algo: str) -> None:
  global total_score, max_score
  print(f" ******** Part {part} - {algo} ******** ")
  result = os.popen(f"python3 grade-mp3-{algo}.py").read()
  score_line = [ln for ln in result.split("\n") if ln.startswith("Score:")][0]
  scores = score_line.split("Score: ")[1].split("/")
  total_score += int(scores[0])
  max_score += int(scores[1])
  print(f"{algo} scheduler score: {scores[0]}/{scores[1]}")

# test for part 1
print(" **************** Part 1 **************** ")
for algo in ["WRR", "SJF"]:
  test(1, algo)

# test for part 2
print(" **************** Part 2 **************** ")
for algo in ["LST", "DM"]:
  test(2, algo)

print(f"Total score: {total_score}/{max_score}")
