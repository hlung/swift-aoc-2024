import Foundation

extension Array where Element: Collection,
                      Element.Element: Equatable,
                      Index == Int,
                      Element.Index == Int {

  func find(_ c: Element.Element) -> Point? {
    for (y, row) in self.enumerated() {
      if let x = row.firstIndex(where: { $0 == c }) {
        return Point(x: x, y: y)
      }
    }
    return nil
  }

  func count(_ c: Element.Element) -> Int {
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

  private func isValid(_ point: Point) -> Bool {
    return point.y >= 0 && point.y < self.count &&
           point.x >= 0 && point.x < self[point.y].count
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

extension [[Int]] {

  subscript(point: Point) -> Int? {
    get {
      guard isValid(point) else { return nil }
      return self[point.y][point.x]
    }
    set {
      guard isValid(point) else { return }
      guard let newValue = newValue else { return }
      self[point.y][point.x] = newValue
    }
  }

}

extension [[Character]] {

  subscript(point: Point) -> Character? {
    get {
      guard isValid(point) else { return nil }
      return self[point.y][point.x]
    }
    set {
      guard isValid(point) else { return }
      guard let newValue = newValue else { return }
      self[point.y][point.x] = newValue
    }
  }

}

//public extension Collection {
//  subscript (safe index: Index) -> Iterator.Element? {
//    return index >= startIndex && index < endIndex ? self[index] : nil
//  }
//}
