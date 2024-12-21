import Testing

@testable import AdventOfCode

struct Day11Tests {
  let testData = """
    125 17
    """

  @Test func testPart1() async throws {
    let day = Day11(data: testData)
//    #expect(
//      "\(day.blink(times: 6))" == "22"
//    )
    #expect(
      "\(day.part1())" == "55312"
    )
  }

  @Test func testPart2() async throws {
    let day = Day11(data: testData)
    #expect(
      "\(day.part2())" == ""
    )
  }
}
