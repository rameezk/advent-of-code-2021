import strutils, sequtils, sugar

let input = readFile("./input.txt").splitLines.filter((line) => not isEmptyOrWhitespace(line)).map(parseInt)
# let input: seq = @[1, 2, 3]

echo input
