import strutils, sequtils, sugar, nre

let input = readFile("./input.txt").splitLines.filter((line) => not isEmptyOrWhitespace(line))

type Direction = enum
  dForward = "forward", dUp = "up", dDown = "down"

converter toDirection(s: string): Direction = parseEnum[Direction](s)

proc parse_line(line: string): (Direction, int) =
  let matches = line.find(re"^(.*)\s(\d)+$").get.captures
  let direction = toDirection(matches[0])
  let by = parseInt(matches[1])
  return (direction, by)
  
proc calculate_product_part_1(input: seq[string]): int =
  var horizontal = 0
  var depth = 0

  for line in input:
    let (direction, by) = parse_line(line)
    case direction:
      of Direction.dForward:
        inc(horizontal, by)
      of Direction.dDown:
        inc(depth, by)
      of Direction.dUp:
        dec(depth, by)

  let product = horizontal * depth
  return product

proc calculate_product_part_2(input: seq[string]): int =
  var horizontal = 0
  var depth = 0
  var aim = 0

  for line in input:
    let (direction, by) = parse_line(line)
    case direction:
      of Direction.dForward:
        inc(horizontal, by)
        inc(depth, (aim * by))
      of Direction.dDown:
        inc(aim, by)
      of Direction.dUp:
        dec(aim, by)

  let product = horizontal * depth
  return product

echo "part 1: ", calculate_product_part_1(input)
echo "part 2: ", calculate_product_part_2(input)
