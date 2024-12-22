import Foundation
import Algorithms

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
      // - Preliminary checks -
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

  func part2() -> Any {
    // ⭐️ Key point
    // The prize point now grows too large for simple for loops.
    // We need to find other shortcuts (Cramer's Rule).
    // 2 variables, 2 equations.

    let machines = machines.map({ m in
      return Machine(
        buttonA: m.buttonA,
        buttonB: m.buttonB,
        prize: m.prize + Point(10000000000000, 10000000000000)
      )
    })

    func cheapestPathCost(_ m: Machine) -> Int {
      print(m)

      // a * m.buttonA.x + b * m.buttonB.x = m.prize.x
      // a * m.buttonA.y + b * m.buttonB.y = m.prize.y

      let coefficients = [
        [m.buttonA.x, m.buttonB.x], // Coefficients of the first equation
        [m.buttonA.y, m.buttonB.y]  // Coefficients of the second equation
      ]

      let constants = [m.prize.x, m.prize.y] // Constant terms of the equations

      if let solution = solveUsingCramersRule2x2(coefficients: coefficients, constants: constants) {
        print("Solution: x = \(solution.a), y = \(solution.b)")

        return solution.a * 3 + solution.b
      } else {
        print("No unique solution.")
        return 0
      }
    }

    var output = 0
    for m in machines {
      let cost = cheapestPathCost(m)
      output += cost
      print(cost, m)
    }
    return output
  }

  /// Solves a system of two linear equations using Cramer's Rule.
  ///
  /// - Parameters:
  ///   - coefficients: A 2D array `[[a1, b1], [a2, b2]]` containing the positive coefficients of the equations.
  ///   - constants: An array `[c1, c2]` containing the constant terms.
  /// - Returns: An optional tuple `(x: Int, y: Int)`, or nil if no unique solution exists.
  func solveUsingCramersRule2x2(coefficients: [[Int]], constants: [Int]) -> (a: Int, b: Int)? {
    guard coefficients.count == 2
            && coefficients.allSatisfy({ $0.count == 2 })
            && constants.count == 2 else {
      print("Invalid input: Must be a 2x2 system.")
      return nil
    }

    // Extract coefficients
    let a1 = coefficients[0][0], b1 = coefficients[0][1]
    let a2 = coefficients[1][0], b2 = coefficients[1][1]
    let c1 = constants[0], c2 = constants[1]

    // Check if coefficients are positive
    if [a1, b1, a2, b2].contains(where: { $0 <= 0 }) {
      print("Invalid input: Coefficients must be positive.")
      return nil
    }

    // Calculate the determinant of the coefficient matrix
    let detA = a1 * b2 - a2 * b1
    guard detA != 0 else {
      print("No unique solution exists: Determinant is zero.")
      return nil
    }

    // Calculate determinants for x and y
    let dx = c1 * b2 - c2 * b1
    let dy = a1 * c2 - a2 * c1

    // Calculate solutions
    let a = dx / detA
    let b = dy / detA

    // !!!!!
    // Make sure it exactly matches
    if c1 != (a * a1) + (b * b1) || c2 != (a * a2) + (b * b2) {
      return nil
    }

    return (a, b)
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
