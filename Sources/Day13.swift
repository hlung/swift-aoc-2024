import Foundation

struct Day13: AdventDay {

  private let machines: [Machine]

  init(data: String) {
    self.machines = data
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .split(separator: "\n\n")
      .compactMap { Machine(data: String($0)) }
  }

  func part1() -> Any {

    func cheapestPathCost(_ m: Machine) -> Int {
      // ⭐️ Key point
      // This is wrong. Even if 100 Button A exceeds prize, 100 Button B may not.🙈
      // preliminary checks
//      if max(m.buttonA.x, m.buttonB.x) * 100 < m.prize.x {
//        return 0
//      }
//      if max(m.buttonA.y, m.buttonB.y) * 100 < m.prize.y {
//        return 0
//      }

      // ⭐️ Key point
      // The problem initially seems to require breadth-first search to find shortest path.
      // But actually, since most steps are redundant.
      // For example, AABB = ABAB = BBAA = BABA all have same position and cost.
      // What matters is actually unique counts of each button (2A2B, 2A3B, 2A4B, ...),
      // which can be iterated by using just 2 for-loops.
      var cheapestCost = 0
      var point = Point(0, 0)

      for a in 0...100 {
        point = m.buttonA * a
        if point.x > m.prize.x {
          break
        }

        for b in 0...100 {
          let point = point + m.buttonB * b
          if point.y > m.prize.y {
            break
          }
          if point == m.prize {
            let cost = (a * 3) + b
            if cheapestCost == 0 || cost < cheapestCost {
              cheapestCost = cost
            }
          }
        }
      }

      return cheapestCost
    }

    var output = 0
    for m in machines {
      let cost = cheapestPathCost(m)
      output += cost
      print(cost, m)
    }
    return output
  }

//  func part1() -> Any {
//
//    func cheapestPathCost(_ m: Machine) -> Int {
//      // preliminary checks
//      if max(m.buttonA.x, m.buttonB.x) * 100 < m.prize.x {
//        return 0
//      }
//      if max(m.buttonA.y, m.buttonB.y) * 100 < m.prize.y {
//        return 0
//      }
//
//      var path: [Move] = []
//      var cheapestCost: Int = 0
//
//      func dfs(move: Move) -> Bool {
////        if move.countA % 10 == 0 && move.countB % 10 == 0 {
//          print(move)
////        }
//        if move.point == m.prize {
//          if cheapestCost == 0 || move.cost < cheapestCost {
//            cheapestCost = move.cost
//          }
//          print(cheapestCost, move)
//          return true
//        }
//        if move.countA > 100 || move.countB > 100 {
////          print(move)
//          return false
//        }
//        if move.point.x > m.prize.x || move.point.y > m.prize.y {
////          print(move)
//          return false
//        }
//
//        // Try button A
//        let moveA = Move(
//          point: move.point + m.buttonA,
//          countA: move.countA + 1,
//          countB: move.countB
//        )
//        path.append(moveA)
//        let resultA = dfs(move: moveA)
//        path.removeLast()
//        if resultA {
//          return resultA
//        }
//
//        // Try button B
//        let moveB = Move(
//          point: move.point + m.buttonB,
//          countA: move.countA,
//          countB: move.countB + 1
//        )
//        path.append(moveB)
//        let resultB = dfs(move: moveB)
//        path.removeLast()
//        if resultB {
//          return resultB
//        }
//
//        return false
//      }
//
//      _ = dfs(move: Move(point: Point(0, 0), countA: 0, countB: 0))
//
//      return cheapestCost
//    }
//
//    var output = 0
//    for m in machines {
//      output += cheapestPathCost(m)
//    }
//    return output
//  }

//  func part1() -> Any {
//    var output = 0
//    for m in machines {
//      var currentPoint = Point(0, 0)
//      var queue: Array<Move> = [Move(point: currentPoint, countA: 0, countB: 0)]
//      var moveSet: Set<Move> = []
//
//      var found = false
//
//      while !queue.isEmpty {
//        print(queue)
//        print()
//
//        let move = queue.removeFirst()
//
//        if move.point == m.prize {
//          found = true
//          break
//        }
//        if move.point.x > m.prize.x || move.point.y > m.prize.y {
//          break
//        }
//        if move.countA > 100 || move.countB > 100 {
//          break
//        }
//
//        queue.append(
//          Move(
//            point: move.point + m.buttonA,
//            countA: move.countA + 1,
//            countB: move.countB
//          )
//        )
//        queue.append(
//          Move(
//            point: move.point + m.buttonB,
//            countA: move.countA,
//            countB: move.countB + 1
//          )
//        )
//      }
//
//    }
//    return output
//  }

  func part2() -> Any {
    return 0
  }

}

private struct Move: Hashable {
  let point: Point
  let countA: Int
  let countB: Int

  var cost: Int {
    return (countA * 3) + countB
  }
}

private struct Machine {
  let buttonA: Point
  let buttonB: Point
  let prize: Point

  init(buttonA: Point, buttonB: Point, prize: Point) {
    self.buttonA = buttonA
    self.buttonB = buttonB
    self.prize = prize
  }

  init?(data: String) {
    let pattern = #"""
    Button A: X([+-]?\d+), Y([+-]?\d+)
    Button B: X([+-]?\d+), Y([+-]?\d+)
    Prize: X=(\d+), Y=(\d+)
    """#

    // Compile the regex
    let regex = try! NSRegularExpression(pattern: pattern, options: [])

    // Perform the matching
    let range = NSRange(data.startIndex..<data.endIndex, in: data)
    let matches = regex.matches(in: data, options: [], range: range)

    // Ensure there's exactly one match
    guard let match = matches.first else { return nil }

    // Extract the coordinates for Button A, Button B, and Prize
    let buttonAX = Int((data as NSString).substring(with: match.range(at: 1)))!
    let buttonAY = Int((data as NSString).substring(with: match.range(at: 2)))!
    let buttonBX = Int((data as NSString).substring(with: match.range(at: 3)))!
    let buttonBY = Int((data as NSString).substring(with: match.range(at: 4)))!
    let prizeX = Int((data as NSString).substring(with: match.range(at: 5)))!
    let prizeY = Int((data as NSString).substring(with: match.range(at: 6)))!

    // Initialize the ClawMachine struct with extracted points
    self.buttonA = Point(x: buttonAX, y: buttonAY)
    self.buttonB = Point(x: buttonBX, y: buttonBY)
    self.prize = Point(x: prizeX, y: prizeY)
  }
}
