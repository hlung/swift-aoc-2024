import Foundation

struct Day10: AdventDay {

  let map: [[Int]]

  init(data: String) {
    self.map = data
      .split(separator: "\n")
      .map { String($0).map { $0.wholeNumberValue! } }
  }

  func part1() -> Any {
    let trailheads = map.points(of: 0)

    // dfs
    var output = 0
    var reached = Set<Point>()
    func findTrails(start: Point, end: Int) {
      let currentVal = map[start]!
      let nextVal = currentVal + 1
      for np in start.neighbors() {
        if map[np] == nextVal, !reached.contains(np) {
          if map[np] == end {
            output += 1
            print(output, start, np)
          }
          else {
            findTrails(start: np, end: end)
          }
          reached.insert(np)
        }
      }
    }

    var finalOutput = 0
    for trailhead in trailheads {
      output = 0
      reached.removeAll()
      findTrails(start: trailhead, end: 9)
//      print(output)
      finalOutput += output
    }

    return finalOutput
  }

  func part2() -> Any {
    let trailheads = map.points(of: 0)

    // dfs
    var output = 0
//    var reached = Set<Point>()
    func findTrails(start: Point, end: Int) {
      let currentVal = map[start]!
      let nextVal = currentVal + 1
      for np in start.neighbors() {
        if map[np] == nextVal/*, !reached.contains(np) */{
          if map[np] == end {
            output += 1
            print(output, start, np)
          }
          else {
            findTrails(start: np, end: end)
          }
//          reached.insert(np)
        }
      }
    }

    var finalOutput = 0
    for trailhead in trailheads {
      output = 0
//      reached.removeAll()
      findTrails(start: trailhead, end: 9)
//      print(output)
      finalOutput += output
    }

    return finalOutput
  }

}

private extension [[Int]] {
  func points(of value: Int) -> [Point] {
    var points = [Point]()
    for (y, row) in enumerated() {
      for (x, num) in row.enumerated() {
        if num == value {
          points.append(Point(x, y))
        }
      }
    }
    return points
  }
}
