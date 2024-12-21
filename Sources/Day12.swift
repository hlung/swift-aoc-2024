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

    func region(at p: Point) -> Region {
      var visited: Set<Point> = []
      let character = map[p]

      // Add connected region to `visited` set
      func dfs(_ p: Point) {
        visited.insert(p)
        map[p] = Constants.empty // clear map point so we don't visit it again
        for np in p.neighbors() {
          if let n = map[np], n == character, !visited.contains(np) {
            dfs(np)
          }
        }
      }
      dfs(p)

      // Count fences using `visited` set
      var fence = 0
      for p in visited {
        let neighbors = p.neighbors()
        var count = 0
        for np in neighbors {
          if !visited.contains(np) {
            count += 1
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
          let r = region(at: p)
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
