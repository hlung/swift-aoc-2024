import Foundation

final class Day05: AdventDay {

  struct Rule: Equatable {
    let a: Int
    let b: Int
  }

  let rules: [Rule]
  let pagesList: [[Int]]

  init(data: String) {
    let comps = data.split(separator: "\n\n")

    self.rules = comps[0]
      .split(separator: "\n")
      .map({ s in
        let array = s.split(separator: "|")
        return Rule(a: Int(array[0])!, b: Int(array[1])!)
      })

    self.pagesList = comps[1]
      .split(separator: "\n")
      .map({ s in
        s.split(separator: ",").map { Int($0)! }
      })
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var goodPagesList: [[Int]] = []

    for pages in pagesList {
      goodPagesList.append(pages)
      for combo in pages.combinations(ofCount: 2) {
        print(combo)
        let violatingRule = Rule(a: combo[1], b: combo[0])
        let isViolatingARule = rules.first { $0 == violatingRule } != nil
        if isViolatingARule {
          goodPagesList.removeLast()
          break
        }
      }
    }

    return goodPagesList.sumMid()
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var badPagesList: [[Int]] = []

    for pages in pagesList {
      for combo in pages.combinations(ofCount: 2) {
        print(combo)
        let violatingRule = Rule(a: combo[1], b: combo[0])
        let isViolatingARule = rules.first { $0 == violatingRule } != nil
        if isViolatingARule {
          badPagesList.append(pages)
          break
        }
      }
    }

    for i in 0..<badPagesList.count {
      var pages = badPagesList[i]

      var swapped = true
      var count = 0
      while swapped {
        count += 1
//        print(count)
        swapped = false
        for j in 0..<pages.count-1 {
          for k in j+1..<pages.count {
            let violatingRule = Rule(a: pages[k], b: pages[j])
            let isViolatingARule = rules.first { $0 == violatingRule } != nil
            if isViolatingARule {
              let dum = pages[k]
              pages[k] = pages[j]
              pages[j] = dum
              swapped = true
              break
            }
          }
        }
      }

      badPagesList[i] = pages
    }

    return badPagesList.sumMid()
  }

}

private extension [[Int]] {
  func sumMid() -> Int {
    return self.reduce(0) { partialResult, pages in
      return partialResult + pages[(pages.count-1)/2]
    }
  }
}
