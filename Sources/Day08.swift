import Foundation

struct Day08: AdventDay {

  let map: [[Character]]

  enum Constants {
    static let empty: Character = "."
    static let antinode: Character = "#"
  }

  var towerPositions: [Character: [Point]] = [:]

  init(data: String) {
    self.map = data.split(separator: "\n").map { Array($0) }

    // Get a set of towers and their positions
    for (y, row) in map.enumerated() {
      for (x, char) in row.enumerated() {
        if char != Constants.empty {
          towerPositions[char, default: []].append(Point(x, y))
        }
      }
    }
  }

  func part1() -> Any {
    var antinodePoints: Set<Point> = []
    var antinodeMap = map

    // for each tower
    // for each location pairs
    // calculate antinode locations. mark it in another map
    for tower in towerPositions {
      for pair in tower.value.permutations(ofCount: 2) {
        let p1 = pair[0], p2 = pair[1]
        let diff = p2 - p1
        let antinodes = [p1 - diff, p2 + diff]
        for ant in antinodes {
          if map[ant] != nil { // ant is within map bounds
            antinodePoints.insert(ant)
            antinodeMap[ant] = Constants.antinode
          }
        }
      }
    }

    // count unique antinodes.
    print(antinodeMap.prettyDescription())
    return antinodePoints.count
  }

  func part2() -> Any {
    return 0
  }

}
