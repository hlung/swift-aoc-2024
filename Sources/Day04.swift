import Foundation

final class Day04: AdventDay {

  let grid: [[Character]]

  init(data: String) {
    self.grid = data.split(separator: "\n").map { Array($0) }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    return countXMASOccurrences(grid: self.grid)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    return countCROSS_MASOccurrences(grid: self.grid)
  }

  // Function to check if the word "XMAS" exists in a given direction
  func countXMASOccurrences(grid: [[Character]]) -> Int {
    let word = "XMAS"
    let wordLength = word.count
    let numRows = grid.count
    let numCols = grid[0].count
    var count = 0

    // Helper function to check a specific direction for the word "XMAS"
    func checkDirection(x: Int, y: Int, dx: Int, dy: Int) -> Bool {
      var currentX = x
      var currentY = y
      for i in 0..<wordLength {
        // Check if we are still inside the bounds of the grid
        if currentX < 0 || currentX >= numCols || currentY < 0 || currentY >= numRows {
          return false
        }
        if grid[currentY][currentX] != word[word.index(word.startIndex, offsetBy: i)] {
          return false
        }
        currentX += dx
        currentY += dy
      }
      return true
    }

    // Iterate through every cell in the grid and check in all 8 directions
    for y in 0..<numRows {
      for x in 0..<numCols {
        // Horizontal (right)
        if checkDirection(x: x, y: y, dx: 1, dy: 0) {
          count += 1
        }
        // Vertical (down)
        if checkDirection(x: x, y: y, dx: 0, dy: 1) {
          count += 1
        }
        // Diagonal (down-right)
        if checkDirection(x: x, y: y, dx: 1, dy: 1) {
          count += 1
        }
        // Diagonal (down-left)
        if checkDirection(x: x, y: y, dx: -1, dy: 1) {
          count += 1
        }
        // Reversed Horizontal (left)
        if checkDirection(x: x, y: y, dx: -1, dy: 0) {
          count += 1
        }
        // Reversed Vertical (up)
        if checkDirection(x: x, y: y, dx: 0, dy: -1) {
          count += 1
        }
        // Reversed Diagonal (up-right)
        if checkDirection(x: x, y: y, dx: 1, dy: -1) {
          count += 1
        }
        // Reversed Diagonal (up-left)
        if checkDirection(x: x, y: y, dx: -1, dy: -1) {
          count += 1
        }
      }
    }

    return count
  }

  // Function to check if the word "XMAS" exists in a given direction
  func countCROSS_MASOccurrences(grid: [[Character]]) -> Int {
    let numRows = grid.count
    let numCols = grid[0].count
    var count = 0

    for y in 1..<numRows-1 {
      for x in 1..<numCols-1 {
        if grid[y][x] == "A" {
          let upLeft = grid[y-1][x-1]
          let downRight = grid[y+1][x+1]
          if (upLeft == "M" && downRight == "S") ||
             (upLeft == "S" && downRight == "M") {

            let upRight = grid[y-1][x+1]
            let downLeft = grid[y+1][x-1]
            if (upRight == "M" && downLeft == "S") ||
               (upRight == "S" && downLeft == "M") {
              count += 1
            }
          }
        }
      }
    }

    return count
  }

}
