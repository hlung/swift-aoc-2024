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

      // ⭐️ Key point
      // Initially it is a Point Set. But there's an edge case where two areas (separated by one cell) may end up adding fence at the same point,
      // producing lower value than it should. So we need to add "Direction" info to the Set element in order to differentiate them.
      // Hence, "Fence" type has both Point and Direction.
      var hFenceSet: Set<Fence> = []
      var vFenceSet: Set<Fence> = []

      for p in visited {
        for d in [Direction.up, Direction.down] {
          let np = p + d.pointDiff
          if !visited.contains(np) {
            hFenceSet.insert(Fence(point: p, direction: d))
          }
        }
        for d in [Direction.left, Direction.right] {
          let np = p + d.pointDiff
          if !visited.contains(np) {
            vFenceSet.insert(Fence(point: p, direction: d))
          }
        }
      }

//      var hDebugMap = self.map
//      var vDebugMap = self.map

      var count = 0
      for p in hFenceSet {
        if !hFenceSet.contains(Fence(point: p.point.right, direction: p.direction)) {
          count += 1
//          hDebugMap[p.point] = "-"
        }
        else {
//          hDebugMap[p.point] = "."
        }
      }
      for p in vFenceSet {
        if !vFenceSet.contains(Fence(point: p.point.down, direction: p.direction)) {
          count += 1
//          vDebugMap[p.point] = "|"
        }
        else {
//          vDebugMap[p.point] = "."
        }
      }
      fence = count

      // -----------
      // debug print
//      for p in hFenceSet {
//        hDebugMap[p] = "-"
//      }
//      for p in vFenceSet {
//        vDebugMap[p] = "|"
//      }

//      print(
//        character,
//        self.map.printPrettyDescription(),
//        hDebugMap.printPrettyDescription(),
//        vDebugMap.printPrettyDescription(),
//        Region(area: visited.count, fence: fence)
//      )
      // -----------

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

}

private struct Region {
  var area: Int
  var fence: Int
}

private struct Fence: Hashable {
  var point: Point
  var direction: Direction
}
