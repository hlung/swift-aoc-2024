import Foundation
import Numerics

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
//    let count = 100_000_000
////    var array: [Int] = []
//    var array: [Int] = .init(repeating: 1, count: count)
//    for n in 1...10 {
//      print(n)
////      var array: [Int] = .init(repeating: 1, count: count)
//      for i in 0...count-1 {
//        if array.count-1 < i {
//          array.append(i)
//        }
//        else {
//          array[i] = i
//        }
//      }
//    }
//
//    return 0
    return blink(times: 25)
  }

  func part2() -> Any {
//    return 0
    return blink(times: 75)
  }

  // Fake
//  func blink(times: StoneType) -> Int {
//    var stones = self.stones
//    stones.reserveCapacity(100_000_000)
//
//    for i in 1...times {
//      for n in 1...10_000_000 {
//        stones.append(0)
//      }
//    }
//    return 0
//  }

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

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}

extension [StoneType] {
  @inlinable public func blink() -> [StoneType] {
    var newStones: [StoneType] = []
    for s in self {
      newStones.append(contentsOf: s.blink())
    }
    return newStones
  }

  func blinkAsync() async throws -> [StoneType] {
    let chunkSize: Int =
      if count < 10_000_000 {
        count
      }
      else {
        count/10
      }

    return try await withThrowingTaskGroup(of: [StoneType].self) { group in
      var output = [StoneType]()
      let chunks = self.chunked(into: chunkSize)
      for array in chunks {
        group.addTask{
          return array.blink()
        }
      }
      for try await array in group {
        output.append(contentsOf: array)
      }
      return output
    }
  }
}

extension StoneType {
//  func blink() -> [Int] {
//    if self == 0 {
//      return [1]
//    }
//
//    if digits % 2 == 0 {
//      return [digits/2, digits/2]
//    }
//
//    return [(self * 2024).digits]
//  }

  public func blink() -> [StoneType] {
    if self == 0 {
      return [1]
    }

//    let string = String(self)
//    if digits % 2 == 0 {
//      return [StoneType(string.firstHalf)!, StoneType(string.secondHalf)!]
//    }

    // This seems to be 2x faster than using String
//    let digitsCount = Int(log10(Double(self))) + 1  // Calculate number of digits
    let digitsCount = self.digits  // Calculate number of digits

    if digitsCount % 2 == 0 {
      let divisor = Int(pow(10.0, Double(digitsCount / 2)))  // Power of 10 to divide the number
      let firstPart = self / divisor  // Get the first part by dividing
      let secondPart = self % divisor  // Get the second part using modulus
      return [firstPart, secondPart]
    }

//    if digits % 2 == 0 {
//      let string = String(self)
//      return [StoneType(string.firstHalf)!, StoneType(string.secondHalf)!]
//    }

    return [self * 2024]
  }
}

extension Int {
  var digits: Int {
    var count = 0
    var num = self
    if (num == 0){
       return 1
    }
    while (num > 0) {
       num = num / 10
       count += 1
    }
    return count
  }
}

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
