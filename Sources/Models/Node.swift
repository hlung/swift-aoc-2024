import Foundation

class Node {
  let number: Int
  var children: [Node] = []

  init(_ number: Int) {
    self.number = number
  }
}
