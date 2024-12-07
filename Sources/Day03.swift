import Foundation

struct Day03: AdventDay {
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
    let input = removeDontDo(input: removeDontDont(input: data))
    return mul(input: input)
  }

  func removeDontDo(input: String) -> String {
    // It uses the non-greedy .*? to ensure it matches the shortest possible text between don't() and do() (important if there are multiple occurrences in the string).
    let pattern = #"don't\(\).*?do\(\)"#
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(input.startIndex..., in: input)
    let matches = regex.matches(in: input, options: [], range: range)
    print("don't_do matches: ", matches.count)
    return regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "")
  }

  func removeDontDont(input: String) -> String {
    // It uses the non-greedy .*? to ensure it matches the shortest possible text between don't() and do() (important if there are multiple occurrences in the string).
    let pattern = #"don't\(\).*?don't\(\)"#
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(input.startIndex..., in: input)
    let matches = regex.matches(in: input, options: [], range: range)
    print("don't_do matches: ", matches.count)
    return regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "don't")
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
