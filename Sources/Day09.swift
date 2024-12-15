import Foundation

struct Day09: AdventDay {

  let data: [Int]
//  let space: [Int]
  
  init(data: String) {
    self.data =
      // drop last number since it's a empty space
      if data.count % 2 == 0 {
        data.dropLast().compactMap { $0.wholeNumberValue }
      }
      else {
        data.compactMap { $0.wholeNumberValue }
      }
//    print(self.data.count)
  }

  func part1() -> Any {
    var disk = [Int?]()
    var isSpace = false
    var id = -1
    for n in data {
      if !isSpace { id += 1 }
      let c = isSpace ? nil : id
      disk.append(contentsOf: Array(repeating: c, count: n))
      isSpace.toggle()
    }
    print(disk.prettyDescription())
    disk.defrag()
    print(disk.prettyDescription())
    return disk.checksum()
  }

  func part1Old() -> Any {
    // I'm starting with determining the frontIndex and backIndex
    var output = 0 {
      didSet { print(output) }
    }
    var frontIndex = 0
    var backIndex = data.reduce(0) { p, n in p + n }
    
    var frontId = 0
    var backId = (data.count - 1) / 2
    
    var frontDataIndex = 0
    var backDataIndex = data.count - 1
    var frontChunkWidth = data[frontDataIndex]
    var backChunkWidth = data[backDataIndex]
    var moreData = true
    var isEmpty = frontChunkWidth == 0

    while moreData {
      if !isEmpty {
        output += frontIndex * frontId
        print(frontIndex, "*", frontId, "=", frontIndex * frontId)

        frontIndex += 1
        frontChunkWidth -= 1
        
        if frontChunkWidth == 0 {
          repeat {
            frontDataIndex += 1
            frontChunkWidth = data[frontDataIndex]

            // ⭐️ Keypoint
            // Some next width is zero
            if frontChunkWidth > 0 {
              // Move to "fill empty spcae" mode
              isEmpty = true
            }
            else {
              // No space, continue reading data
              frontId += 1
              frontDataIndex += 1
              frontChunkWidth = data[frontDataIndex]
            }
          } while frontChunkWidth == 0
        }
      }
      else {
        output += frontIndex * backId
        print(frontIndex, "*", backId, "=", frontIndex * backId)
        
        frontIndex += 1
        backIndex -= 1

        frontChunkWidth -= 1
        backChunkWidth -= 1
        
        if backChunkWidth == 0 {
          // Move to next data from the back
          repeat {
            backDataIndex -= 1
            // ⭐️ Keypoint
            // Don't forget to take the empty space into account
            // when updating backIndex
            let backSpaceWidth = data[backDataIndex]
            backIndex -= backSpaceWidth

            backDataIndex -= 1
            backChunkWidth = data[backDataIndex]

            backId -= 1
          } while backChunkWidth == 0
        }
        
        if frontChunkWidth == 0 {
          repeat {
            frontDataIndex += 1
            frontChunkWidth = data[frontDataIndex]

            // ⭐️ Keypoint
            // Some next width is zero
            if frontChunkWidth > 0 {
              // Move back to "read data" mode
              isEmpty = false
              frontId += 1
            }
            else {
              // Continue filling space
              frontDataIndex += 1
              frontChunkWidth = data[frontDataIndex]
            }
          } while frontChunkWidth == 0
        }
      }
      moreData = frontIndex < backIndex
    }
    
    return output
  }

  func part2() -> Any {
    return 0
  }

}

private extension [Int?] {
  func prettyDescription() -> String {
    map { $0 == nil ? "." : "\($0!)" }.joined(separator: "|")
  }

  func checksum() -> Int {
    var output = 0
    for (i, n) in self.compacted().enumerated() {
      output += i * n
      print(output, ":", i*n, "=", i, "*", n)
    }
    return output
  }

  mutating func defrag() {
    var lastDataIndex = self.count

    func nextLastDataIndex() -> Int {
      repeat {
        lastDataIndex -= 1
      }
      while self[lastDataIndex] == nil
      return lastDataIndex
    }

    lastDataIndex = nextLastDataIndex()

    for (i, n) in self.enumerated() {
      if n == nil {
        self[i] = self[lastDataIndex]
        self[lastDataIndex] = nil
        lastDataIndex = nextLastDataIndex()
      }
      if i >= lastDataIndex {
        break
      }
    }
  }
}
