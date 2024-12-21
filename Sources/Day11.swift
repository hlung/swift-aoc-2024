import Foundation

struct Day11: AdventDay {

  let stones: [Stone]

  init(data: String) {
    self.stones = data
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .split(separator: " ")
      .map { Stone(String($0)) }
  }

  func part1() -> Any {
    return blink(times: 25)
  }

  func blink(times: Int) -> Any {
    var stones: [Stone] = stones
    print(stones.map({ s in s.string }))

    var newStones: [Stone] = []
    for _ in 1...times {
      for s in stones {
        newStones.append(contentsOf: s.blink())
      }
      stones = newStones
      newStones = []
//      print(stones.map({ s in s.string }))

    }
    return stones.count
  }

  func part2() -> Any {
    return 0
  }

}

struct Stone {
  let string: String

  init(_ string: String) {
    self.string = string
  }

  func blink() -> [Stone] {
    if string == "0" {
      return [Stone("1")]
    }
    else if string.count % 2 == 0 {
      return [Stone(string.firstHalf), Stone(string.secondHalf)]
    }
    else {
      return [Stone(String(Int(string)! * 2024))]
    }
  }
}

extension String {
  var firstHalf: String {
    let index = index(startIndex, offsetBy: count / 2)
    return String(self[..<index]).trimmingPrefixZeros
  }

  var secondHalf: String {
    let index = index(startIndex, offsetBy: count / 2)
    return String(self[index...]).trimmingPrefixZeros
  }

  var trimmingPrefixZeros: String {
    return String(describing: Int(self) ?? 0)
  }
}
