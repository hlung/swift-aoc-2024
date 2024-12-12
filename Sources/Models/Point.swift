struct Point: Hashable, CustomStringConvertible {
  let x: Int
  let y: Int

  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }

  init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }

  static func + (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  static func - (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  static func * (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
  }

  static func * (lhs: Point, value: Int) -> Point {
    return Point(x: lhs.x * value, y: lhs.y * value)
  }

  static func diff(lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  var description: String {
    return "Point(\(x), \(y))"
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
