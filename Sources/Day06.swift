import Foundation

private let empty: Character = "."
private let man: Character = "^"
private let obstacle: Character = "#"
private let passed: Character = "X"

struct Day06: AdventDay {

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
        // ⭐️ Keypoint
        // We find a loop by checking when we hit an obstacle,
        // if that obstacle is hit twice while travelling in the same direction,
        // then it is a loop.
        if newMap[hitObstaclePoint] == currentDirection.obstacle() {
          // found loop
//          print(newMap.map { String($0) })
          return true
        }
        // ⭐️ Keypoint
        // We only add obstacle marking ONLY if the map has no obstacle before.
        // The obstacle has a "direction information" ("D", "U", "L", "R" rather than just one "O")
        // because we may be turning in the same spot twice, but if we are moving in different direction then it may not be a loop.
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

}
