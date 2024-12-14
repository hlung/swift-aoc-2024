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
    // I'm starting with determining the frontIndex and backIndex
    var output = 0 {
      didSet { print(output) }
    }
    var frontIndex = 0
    var backIndex = data.reduce(0) { p, n in p + n }
    
    var frontId = 0
    var backId = (data.count - 1) / 2
    
    var isEmpty = false
    var frontDataIndex = 0
    var backDataIndex = data.count - 1
    var frontChunkWidth = data[frontDataIndex]
    var backChunkWidth = data[backDataIndex]
    var moreData = true

    while moreData {
      if !isEmpty {
        output += frontIndex * frontId
        print(frontIndex, "*", frontId, "=", frontIndex * frontId)

        frontIndex += 1

        frontChunkWidth -= 1
        
        if frontChunkWidth == 0 {
          frontId += 1
          isEmpty = true
          frontDataIndex += 1
          frontChunkWidth = data[frontDataIndex]
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
          backDataIndex -= 1
          // ⭐️ Keypoint
          // Don't forget to take the empty space into account
          // when updating backIndex
          backIndex -= data[backDataIndex]
          backDataIndex -= 1
          backChunkWidth = data[backDataIndex]
          backId -= 1
        }
        
        if frontChunkWidth == 0 {
          isEmpty = false
          frontDataIndex += 1
          frontChunkWidth = data[frontDataIndex]
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
