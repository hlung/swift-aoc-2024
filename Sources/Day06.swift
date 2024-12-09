import Foundation

private let empty: Character = "."
private let man: Character = "^"
private let obstacle: Character = "#"
private let passed: Character = "X"

final class Day06: AdventDay {

  var map: [[Character]]

  init(data: String) {
    self.map = data.split(separator: "\n").map { Array($0) }
  }

  func part1() -> Any {
    var currentPoint = map.find(man)!
    var currentDirection = Direction.up

    while let meetObstaclePoint = map.run(startPoint: currentPoint, direction: currentDirection) {
      currentPoint = meetObstaclePoint
      currentDirection = currentDirection.turnRight()
    }

//    print(map.map { String($0) })
    return map.count(passed)
  }

  func part2() -> Any {
    return 0
  }

}

extension [[Character]] {

  // Returns nil if run out of map. Else return where it hits obstacle.
  mutating func run(startPoint: Point, direction: Direction) -> Point? {
    var currentPoint = startPoint

    while true {
      self[currentPoint] = passed
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

struct Point {
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
}
