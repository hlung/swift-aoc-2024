import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  var firstList: [Int] = []
  var secondList: [Int] = []

  init(data: String) {
    self.data = data

    _ = data.split(separator: "\n").map {
      let numbers = $0.split(separator: " ").compactMap { Int($0) }
      self.firstList.append(numbers[0])
      self.secondList.append(numbers[1])
    }

    firstList.sort()
    secondList.sort()
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var output = 0
    for (a, b) in zip(firstList, secondList) {
      output += abs(a - b)
    }
    return output
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var output = 0
    for a in firstList {
      let occurenceInSecondlist = secondList.count { $0 == a }
      output += a * occurenceInSecondlist
    }
    return output
  }
}
