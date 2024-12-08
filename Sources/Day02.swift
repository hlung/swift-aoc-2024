import Foundation

final class Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  var reports: [[Int]] = []

  init(data: String) {
    self.data = data

    for line in data.split(separator: "\n") {
      let numbers: [Int] = line.split(separator: " ").compactMap { Int($0) }
      self.reports.append(numbers)
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var output = 0

    for numbers in reports {
      if isSafe(numbers: numbers) {
        output += 1
      }
    }

    return output
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var output = 0

    for numbers in reports {

      if isSafe(numbers: numbers) {
        output += 1
        continue
      }
      else {
        for i in 0..<numbers.count {
          var newNumbers = numbers
          newNumbers.remove(at: i)

          if isSafe(numbers: newNumbers) {
            output += 1
            break
          }
        }
      }

    }

    return output
  }

  func isSafe(numbers: [Int]) -> Bool {
    return isSafe(numbers: numbers, isAsc: true)
    || isSafe(numbers: numbers, isAsc: false)
  }

  func isSafe(numbers: [Int], isAsc: Bool) -> Bool {
    var pass = true
    var ref = numbers[0]
    for i in 1..<numbers.count {
      #if DEBUG
      print(ref, numbers[i])
      #endif
      guard (ref < numbers[i]) == isAsc else {
        pass = false
        break
      }
      let diff = abs(ref - numbers[i])
      guard 1 <= diff, diff <= 3 else {
        pass = false
        break
      }
      ref = numbers[i]
    }
    #if DEBUG
    print(pass, numbers)
    #endif
    return pass
  }

}
