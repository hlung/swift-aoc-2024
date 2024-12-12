extension [[Character]] {

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
      return self[safe: point.y]?[safe: point.x]
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

  func prettyDescription() {
    // Print column indices
    print("    ", terminator: "")
    for x in 0..<(first?.count ?? 0) {
      if x % 10 == 0 {
        print(x / 10, terminator: "")
      }
      else {
        print(" ", terminator: "")
      }
    }
    print()
    print("    ", terminator: "")
    for x in 0..<(first?.count ?? 0) {
      print(x % 10, terminator: "")
    }
    print()

    // Print each row with row index
    for (y, row) in enumerated() {
      print(String(format: "%3d", y), terminator: " ")
      for element in row {
        print(element, terminator: "")
      }
      print()
    }
  }

}

public extension Collection {
  subscript (safe index: Index) -> Iterator.Element? {
    return index >= startIndex && index < endIndex ? self[index] : nil
  }
}
