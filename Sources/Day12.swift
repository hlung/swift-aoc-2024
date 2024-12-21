import Foundation

struct Day12: AdventDay {

  let map: [[Character]]

  enum Constants {
    static let empty: Character = "."
  }

  init(data: String) {
    self.map = data.split(separator: "\n").map { Array($0) }
  }

  func part1() -> Any {
    var map = map
    var output: [(Character, Region)] = []

    func region(at p: Point, condition: Character) -> Region {
      var visited: Set<Point> = []

      func dfs(_ p: Point) {
        visited.insert(p)
        for np in p.neighbors() {
          if let n = map[np], n == condition, !visited.contains(np) {
            dfs(np)
          }
        }
      }
      dfs(p)

      var fence = 0

      for p in visited {
        let neighbors = p.neighbors()
        map[p] = Constants.empty // clear map at that point so we don't visit again
        var count = neighbors.count
        for np in neighbors {
          if visited.contains(np) {
            count -= 1
          }
        }
        fence += count
      }

      return Region(area: visited.count, fence: fence)
    }

    for (y, row) in map.enumerated() {
      for (x, _) in row.enumerated() {
        let p = Point(x, y)
        if let c = map[p], c != Constants.empty {
          let r = region(at: p, condition: c)
          output.append((c, r))
        }
      }
    }

    return output.reduce(into: 0) { p, t in
      let (c, r) = t
      p += r.area * r.fence
      print("\(c) -> \(r.area) * \(r.fence) = \(r.area * r.fence)")
    }
  }

  func part2() -> Any {
    return 0
  }

}

private struct Region {
  var area: Int
  var fence: Int
}
