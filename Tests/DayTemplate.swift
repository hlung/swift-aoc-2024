import Testing

@testable import AdventOfCode

struct DayTemplateTests {
  let testData = """

    """

  @Test func testPart1() async throws {
    let challenge = DayTemplate(data: testData)
    #expect(String(describing: challenge.part1()) == "")
  }

  @Test func testPart2() async throws {
    let challenge = DayTemplate(data: testData)
    #expect(String(describing: challenge.part2()) == "")
  }
}
