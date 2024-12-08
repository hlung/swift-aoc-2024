import Testing

@testable import AdventOfCode

final class DayNTests {
  let testData = """
    """

  @Test func testPart1() async throws {
    let challenge = DayN(data: testData)
    #expect(String(describing: challenge.part1()) == "")
  }

  @Test func testPart2() async throws {
    let challenge = DayN(data: testData)
    #expect(String(describing: challenge.part2()) == "")
  }
}
