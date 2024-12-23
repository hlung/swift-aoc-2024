import Foundation

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

  func neighbors() -> [Point] {
    return [
      self + Point(0, -1),
      self + Point(0, 1),
      self + Point(-1, 0),
      self + Point(1, 0),
    ]
  }

  var left: Point { self + Direction.left.pointDiff }
  var right: Point { self + Direction.right.pointDiff }
  var up: Point { self + Direction.up.pointDiff }
  var down: Point { self + Direction.down.pointDiff }

}
