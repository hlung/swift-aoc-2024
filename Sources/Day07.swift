import Foundation

struct Day07: AdventDay {

  let equations: [Equation]

  init(data: String) {
    self.equations = data.split(separator: "\n").map { Equation(string: String($0)) }
  }

  func part1() -> Any {
    var output = 0
    for e in equations {
      if e.isValid() {
        output += e.result
//        print(output)
      }
    }
    return output
  }

  func part2() -> Any {
    var output = 0
    for e in equations {
      if e.isValid2() {
        output += e.result
//        print(output)
      }
    }
    return output
  }

  struct Equation {
    let result: Int
    let numbers: [Int]

    init(string: String) {
      // Split the string by the colon
      let components = string.split(separator: ": ")

      // Trim whitespace and convert the first component to an integer
      let resultString = components[0].trimmingCharacters(in: .whitespaces)
      guard let result = Int(resultString) else {
        fatalError("Invalid result format")
      }

      // Split the second component by spaces, trim whitespace, and convert to integers
      let numbersString = components[1].trimmingCharacters(in: .whitespaces)
      let numbers = numbersString.split(separator: " ").compactMap { Int($0.trimmingCharacters(in: .whitespaces))
      }

      // Assign the parsed values to the properties
      self.result = result
      self.numbers = numbers
    }

    func isValid() -> Bool {
      let firstNode = Node(numbers[0])
      var node = firstNode
      for n in numbers.dropFirst() {
        let newNode = Node(n)
        node.children.append(newNode)
        node = newNode
      }

      var path: [Int] = [] {
        didSet {
//          print(result, path)
        }
      }

      func dfs(node: Node) -> Bool {
        if path.isEmpty {
          path.append(node.number)
          for c in node.children {
            return dfs(node: c)
          }
        }
        else {
          // Try plus
          path.append(path.last! + node.number)
          if node.children.isEmpty {
            if path.last == result {
              return true
            }
          }
          else {
            for c in node.children {
              // ⭐️ Keypoint
              // Cannot just `return dfs(node: c)` here because it will exit everything
              // as soon as it finishes first leaf, which is too early.
              if dfs(node: c) {
                return true
              }
            }
          }
          path.removeLast()

          // Try multiply
          path.append(path.last! * node.number)
          if node.children.isEmpty {
            if path.last == result {
              return true
            }
          }
          else {
            for c in node.children {
              if dfs(node: c) {
                return true
              }
            }
          }
          path.removeLast()
        }
        return false
      }

      return dfs(node: firstNode)
    }

    // I could refactor this to take an array of operators,
    // but I'm too lazy :P
    func isValid2() -> Bool {
      let firstNode = Node(numbers[0])
      var node = firstNode
      for n in numbers.dropFirst() {
        let newNode = Node(n)
        node.children.append(newNode)
        node = newNode
      }

      var path: [Int] = [] {
        didSet {
//          print(result, path)
        }
      }

      func dfs(node: Node) -> Bool {
        if path.isEmpty {
          path.append(node.number)
          for c in node.children {
            return dfs(node: c)
          }
        }
        else {
          // Try plus
          path.append(path.last! + node.number)
          if node.children.isEmpty {
            if path.last == result {
              return true
            }
          }
          else {
            for c in node.children {
              // ⭐️ Keypoint
              // Cannot just `return dfs(node: c)` here because it will exit everything
              // as soon as it finishes first leaf, which is too early.
              if dfs(node: c) {
                return true
              }
            }
          }
          path.removeLast()

          // Try multiply
          path.append(path.last! * node.number)
          if node.children.isEmpty {
            if path.last == result {
              return true
            }
          }
          else {
            for c in node.children {
              if dfs(node: c) {
                return true
              }
            }
          }
          path.removeLast()

          // Try concat
          path.append(path.last! ||| node.number)
          if node.children.isEmpty {
            if path.last == result {
              return true
            }
          }
          else {
            for c in node.children {
              if dfs(node: c) {
                return true
              }
            }
          }
          path.removeLast()
        }
        return false
      }

      return dfs(node: firstNode)
    }
  }

}

private class Node {
  let number: Int
  var children: [Node] = []

  init(_ number: Int) {
    self.number = number
  }
}

infix operator |||

private func ||| (left: Int, right: Int) -> Int {
  // Convert both numbers to strings
  let leftString = String(left)
  let rightString = String(right)

  // Concatenate the strings
  let concatenatedString = leftString + rightString

  // Convert the concatenated string back to an integer
  return Int(concatenatedString) ?? 0
}
