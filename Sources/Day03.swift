import Foundation

final class Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  init(data: String) {
    self.data = data
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    return mul(input: data)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var output = 0
    let input = data
    let regexPattern = #"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)"#
    let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
    let range = NSRange(input.startIndex..., in: input)
    var enabled = true

    // Find all matches in the input string
    let matches = regex.matches(in: input, options: [], range: range)

    for match in matches {
      let matchedString = (input as NSString).substring(with: match.range)
      print("Matched: \(matchedString)")

      if enabled && matchedString.hasPrefix("mul") {
        if let firstRange = Range(match.range(at: 1), in: input),
           let secondRange = Range(match.range(at: 2), in: input),
           let x = Int(input[firstRange]),
           let y = Int(input[secondRange]) {
          //          print("Found mul(\(x),\(y))")
          output += (x*y)
        }
      }
      if matchedString.hasPrefix("don't(") {
        enabled = false
      }
      if matchedString.hasPrefix("do(") {
        enabled = true
      }
    }

    return output
  }

  func mul(input: String) -> Int {
    var output = 0

    let input = input
    let regex = #"mul\((\d{1,3}),(\d{1,3})\)"#

    do {
      let regex = try NSRegularExpression(pattern: regex, options: [])
      let range = NSRange(input.startIndex..., in: input)

      let matches = regex.matches(in: input, options: [], range: range)
      print(matches.count)

      for match in matches {
        if let firstRange = Range(match.range(at: 1), in: input),
           let secondRange = Range(match.range(at: 2), in: input),
           let x = Int(input[firstRange]),
           let y = Int(input[secondRange]) {
          //          print("Found mul(\(x),\(y))")
          output += (x*y)
        }
      }
    } catch {
      print("Invalid regex pattern")
    }

    return output
  }

}
