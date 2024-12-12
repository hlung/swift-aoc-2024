struct Point: Hashable {
  let x: Int
  let y: Int

  static func + (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }
}

class Node {
  let number: Int
  var children: [Node] = []

  init(_ number: Int) {
    self.number = number
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