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
      guard point.y >= 0 && point.y < self.count,
            point.x >= 0 && point.x < self[point.y].count else {
        return nil
      }
      return self[point.y][point.x]
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

}
