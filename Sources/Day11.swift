import Foundation

struct Day11: AdventDay {

  let stones: [Int]

  init(data: String) {
    self.stones = data
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .split(separator: " ")
      .map { Int($0) ?? 0 }
  }

  func part1() -> Any {
    return blink(times: 25)
  }

  func blink(times: Int) -> Any {
    var stones: [Int] = stones
    print(stones)

    var newStones: [Int] = []
    for i in 1...times {
      newStones = stones.blink()
      stones = newStones
      newStones.removeAll(keepingCapacity: true)
//      print(stones.map({ s in s.string }))
      print("blink \(i): stones count: \(stones.count)")
    }
    return stones.count
  }

  func part2() -> Any {
    return blink(times: 40)
  }

}

extension [Int] {
  func blink() -> [Int] {
    var newStones: [Int] = []
    for s in self {
      newStones.append(contentsOf: s.blink())
    }
    return newStones
  }
}

extension Int {
  func blink() -> [Int] {
    if self == 0 {
      return [1]
    }

    let string = String(self)
    if string.count % 2 == 0 {
      return [Int(string.firstHalf)!, Int(string.secondHalf)!]
    }

    return [self * 2024]
  }
}

//struct Stone {
//  let string: String
//
//  init(_ string: String) {
//    self.string = string
//  }
//
//  func blink() -> [Stone] {
//    if string == "0" {
//      return [Stone("1")]
//    }
//    else if string.count % 2 == 0 {
//      return [Stone(string.firstHalf), Stone(string.secondHalf)]
//    }
//    else {
//      return [Stone(String(Int(string)! * 2024))]
//    }
//  }
//}

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
