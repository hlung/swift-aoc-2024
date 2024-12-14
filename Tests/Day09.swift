import Testing

@testable import AdventOfCode

struct Day09Tests {
  let testData = """
    2333133121414131402
    """

  @Test func testPart1() async throws {
    let day = Day09(data: testData)
    #expect(
      "\(day.part1())" == "1928"
    )
  }

  @Test func testPart2() async throws {
    let day = Day09(data: testData)
    #expect(
      "\(day.part2())" == ""
    )
  }
}
