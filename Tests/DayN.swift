import Testing

@testable import AdventOfCode

struct DayTests {
  let testData = """
    """

  @Test func testPart1() async throws {
    let challenge = Day(data: testData)
    #expect(String(describing: challenge.part1()) == "")
  }

  @Test func testPart2() async throws {
    let challenge = Day(data: testData)
    #expect(String(describing: challenge.part2()) == "")
  }
}
