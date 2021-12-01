import strutils, sequtils, sugar

let input: seq[int] = readFile("./input.txt").splitLines.filter((line) => not isEmptyOrWhitespace(line)).map(parseInt)

proc count_increases(input: seq[int]): int =
  var count = 0
  let max_counter = len(input) - 1 - 1

  for i in 0..max_counter:
    if input[i+1] > input[i]:
      inc(count)

  return count

proc build_window_sums(input: seq[int], window_size: int): seq[int] =
  let max_counter = len(input) - window_size

  var window_sums: seq[int]
  for i in 0..max_counter:
    var sum = 0
    for j in i..i+window_size-1:
      sum = sum + input[j]
    window_sums.add(sum)

  return window_sums

echo "Part 1: ", count_increases(input)
echo "Part 2: ", count_increases(build_window_sums(input, 3))
