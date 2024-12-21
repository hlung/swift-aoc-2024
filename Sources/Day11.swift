import Foundation

public typealias StoneType = Int

struct Day11: AdventDay {

  let stones: [StoneType]

  init(data: String) {
    stones = data
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .split(separator: " ")
      .map { StoneType($0) ?? 0 }
  }

  func part1() -> Any {
    return blink(times: 25)
  }

  func part2() -> Any {
    return blink(times: 75)
  }

  func blink(times: StoneType) -> Any {
    var dict: [Int: Int] = [:]
    for s in stones {
      dict[s, default: 0] += 1
    }
    print(stones)

    for time in 1...times {
      for (key, count) in dict {
        // ⭐️ Key point
        // Since the same stone will create the same stones,
        // we can greatly optimize it by updating the count of involved stones
        // all at once (not one by one).
        let new = key.blink()
        dict[key]! -= count
        for s in new {
          dict[s, default: 0] += count
        }
      }
      print("blink \(time): stones count: \(dict.values.reduce(0) { $0 + $1 })")
    }

    return dict.values.reduce(0) { $0 + $1 }
  }

}

extension StoneType {

  public func blink() -> [StoneType] {
    if self == 0 {
      return [1]
    }

    let string = String(self)
    if string.count % 2 == 0 {
      return [StoneType(string.firstHalf)!, StoneType(string.secondHalf)!]
    }

    // This seems to be 2x faster than using String
//    let digitsCount = self.digits  // Calculate number of digits
//
//    if digitsCount % 2 == 0 {
//      let divisor = Int(pow(10.0, Double(digitsCount / 2)))  // Power of 10 to divide the number
//      let firstPart = self / divisor  // Get the first part by dividing
//      let secondPart = self % divisor  // Get the second part using modulus
//      return [firstPart, secondPart]
//    }

    return [self * 2024]
  }
}

//extension Int {
//  var digits: Int {
//    var count = 0
//    var num = self
//    if (num == 0){
//       return 1
//    }
//    while (num > 0) {
//       num = num / 10
//       count += 1
//    }
//    return count
//  }
//}

extension String {
  var firstHalf: String {
    let index = index(startIndex, offsetBy: count / 2)
    return String(self[..<index])//.trimmingPrefixZeros
  }

  var secondHalf: String {
    let index = index(startIndex, offsetBy: count / 2)
    return String(self[index...])//.trimmingPrefixZeros
  }

  var trimmingPrefixZeros: String {
    return String(describing: Int(self) ?? 0)
  }
}
