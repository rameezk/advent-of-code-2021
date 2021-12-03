import strutils, sequtils, sugar

let input = readFile("./input.txt").splitLines.filter((line) => not isEmptyOrWhitespace(line))

proc count_bit_occurences(input: seq[string]): (seq[int], seq[int]) =
  let size = input[0].len
  var count_0s: seq[int] = newSeqWith(size, 0)
  var count_1s: seq[int] = newSeqWith(size, 0)
   
  for line in input:
    for idx, bit in line:
      if parseInt($bit) == 0:
        inc(count_0s[idx])
      else:
        inc(count_1s[idx])

  return (count_0s, count_1s)

proc calculate_power_consumption(input: seq[string]): int =
  let (count_0s, count_1s) = count_bit_occurences(input)
  var gamma = ""
  var epsilon = ""
  for i in 0..len(count_0s)-1:
    if count_0s[i] > count_1s[i]:
      gamma.add("0")
      epsilon.add("1")
    else:
      gamma.add("1")
      epsilon.add("0")

  let gamma_dec = fromBin[int](gamma)
  let epsilon_dec = fromBin[int](epsilon)
  let product = gamma_dec * epsilon_dec
  return product

proc get_bit_to_keep(count_0s: seq[int], count_1s: seq[int], index: int, reverse: bool = false): int =
  var bit = 0
  if count_0s[index] == count_1s[index]:
    bit = 1
  elif count_0s[index] > count_1s[index]:
    bit = 0
  else:
    bit = 1

  if reverse:
    if bit == 0:
      bit = 1
    else:
      bit = 0

  return bit

proc get_indexes_to_delete(input: seq[string], bit_to_keep: int, index: int): seq[int] =
  var to_delete: seq[int] = @[]

  for i, l in input:
    if parseInt($l[index]) != bit_to_keep:
      to_delete.add(i)

  return to_delete

proc delete_indexes(input: seq[string], indexes_to_delete: seq[int]): seq[string] =
  var res: seq[string] = input
  if res.len > 1:
    for count, index_to_delete in indexes_to_delete:
      res.delete(index_to_delete - count)
  return res

proc calculate_life_support_rating(input: seq[string]): int =
  var oxygen_generator_rating: seq[string] = input
  var co2_scrubber_rating: seq[string] = input

  var (count_0s_oxy, count_1s_oxy) = count_bit_occurences(input)
  var count_0s_co2 = count_0s_oxy
  var count_1s_co2 = count_1s_oxy

  let size = len(count_0s_oxy) 

  for i in 0..size-1:
    (count_0s_oxy, count_1s_oxy) = count_bit_occurences(oxygen_generator_rating)
    (count_0s_co2, count_1s_co2) = count_bit_occurences(co2_scrubber_rating)

    let bit_to_keep_oxy = get_bit_to_keep(count_0s_oxy, count_1s_oxy, i)
    let bit_to_keep_co2 = get_bit_to_keep(count_0s_co2, count_1s_co2, i, reverse=true)

    let indexes_to_delete_oxy = get_indexes_to_delete(oxygen_generator_rating, bit_to_keep_oxy, i)
    let indexes_to_delete_co2 = get_indexes_to_delete(co2_scrubber_rating, bit_to_keep_co2, i)

    oxygen_generator_rating = delete_indexes(oxygen_generator_rating, indexes_to_delete_oxy)
    co2_scrubber_rating = delete_indexes(co2_scrubber_rating, indexes_to_delete_co2)

  let oxy_dec = fromBin[int](oxygen_generator_rating[0])
  let co2_dec = fromBin[int](co2_scrubber_rating[0])
  let product = oxy_dec * co2_dec
  return product

echo "Part 1: ", calculate_power_consumption(input)
echo "Part 2: ", calculate_life_support_rating(input)
