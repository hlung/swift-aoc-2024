import Foundation

private let empty: Character = "."
private let man: Character = "^"
private let obstacle: Character = "#"
private let passed: Character = "X"

final class Day06: AdventDay {

  let map: [[Character]]

  init(data: String) {
    self.map = data.split(separator: "\n").map { Array($0) }
  }

  func part1() -> Any {
    var map = map
    var currentPoint = map.find(man)!
    var currentDirection = Direction.up

    while let hitObstaclePoint = map.run(
      startPoint: currentPoint,
      direction: currentDirection,
      passedMarking: passed
    ) {
      currentPoint = hitObstaclePoint
      currentDirection = currentDirection.turnRight()
    }

//    print(map.map { String($0) })
    return map.count(passed)
  }

  func part2() -> Any {
    let startPoint = map.find(man)!
    var loopCount = 0

    for (y, row) in map.enumerated() {
      for (x, c) in row.enumerated() {
        if c == empty {
          var newMap = map
          newMap[Point(x: x, y: y)] = obstacle
          if findLoop(in: newMap, startPoint: startPoint) {
            loopCount += 1
          }
        }
      }
    }

    func findLoop(in newMap: [[Character]], startPoint: Point) -> Bool {
      var newMap = newMap
      var currentPoint = startPoint
      var currentDirection = Direction.up

      while let hitObstaclePoint = newMap.run(
        startPoint: currentPoint,
        direction: currentDirection,
        passedMarking: nil
      ) {
        if newMap[hitObstaclePoint] == currentDirection.obstacle() {
          // found loop
//          print(newMap.map { String($0) })
          return true
        }
        if newMap[hitObstaclePoint] == empty {
          newMap[hitObstaclePoint] = currentDirection.obstacle()
        }
        currentPoint = hitObstaclePoint
        currentDirection = currentDirection.turnRight()
      }
      return false
    }

    return loopCount
  }

}

private extension [[Character]] {

  // Returns nil if run out of map. Else return where it hits obstacle.
  mutating func run(startPoint: Point, direction: Direction, passedMarking: Character?) -> Point? {
    var currentPoint = startPoint

    while true {
      if let passedMarking {
        self[currentPoint] = passedMarking
      }
      let nextPoint = currentPoint + direction.pointDiff

      if self[nextPoint] == nil {
        return nil
      }
      if self[nextPoint] == obstacle {
        return currentPoint
      }

      currentPoint = nextPoint
    }

    return nil
  }

  func find(_ c: Character) -> Point? {
    for (y, row) in self.enumerated() {
      if let x = row.firstIndex(of: c) {
        return Point(x: x, y: y)
      }
    }
    return nil
  }

  func count(_ c: Character) -> Int {
    var count = 0
    for row in self {
      for char in row {
        if char == c {
          count += 1
        }
      }
    }
    return count
  }

  subscript(point: Point) -> Character? {
    get {
      guard point.y >= 0 && point.y < self.count,
            point.x >= 0 && point.x < self[point.y].count else {
        return nil
      }
      return self[point.y][point.x]
    }
    set {
      guard point.y >= 0 && point.y < self.count,
            point.x >= 0 && point.x < self[point.y].count,
            let newValue = newValue else {
        return
      }
      self[point.y][point.x] = newValue
    }
  }

}

struct Point: Hashable {
  let x: Int
  let y: Int

  static func + (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }
}

enum Direction {
  case up, down, left, right

  var pointDiff: Point {
    switch self {
    case .up:
      return .init(x: 0, y: -1)
    case .down:
      return .init(x: 0, y: 1)
    case .left:
      return .init(x: -1, y: 0)
    case .right:
      return .init(x: 1, y: 0)
    }
  }

  func turnRight() -> Direction {
    switch self {
    case .up:
      return .right
    case .down:
      return .left
    case .left:
      return .up
    case .right:
      return .down
    }
  }

  func obstacle() -> Character {
    switch self {
    case .up:
      return "U"
    case .down:
      return "D"
    case .left:
      return "L"
    case .right:
      return "R"
    }
  }
}
