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
      newStones.removeAll(keepingCapacity: true)

      // This won't compile in Swift 6...
      let semaphore = DispatchSemaphore(value: 0)
      Task {
        // Serial
        newStones = stones.blink()
        // Concurrent
//        newStones = try await stones.blinkAsync()
        semaphore.signal()
      }
      semaphore.wait()

      stones = newStones
//      print(stones)
      print("blink \(i): stones count: \(stones.count)")
    }

    return stones.count
  }

  func part2() -> Any {
    return blink(times: 40)
  }

}

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
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

  func blinkAsync() async throws -> [Int] {
    let chunkSize: Int =
      if count < 10_000_000 {
        count
      }
      else {
        count/10
      }

    return try await withThrowingTaskGroup(of: [Int].self) { group in
      var output = [Int]()
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

extension Int {
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

extension Int {
  var digits: Int {
    var num = self
    var count = 0
    while num != 0 {
      let digit = abs(num % 10)
      if digit != 0 {
        count += 1
      }
      num = num / 10
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
