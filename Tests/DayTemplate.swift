import Testing

@testable import AdventOfCode

struct DayTemplateTests {
  let testData = """

    """

  @Test func testPart1() async throws {
    let day = DayTemplate(data: testData)
    #expect(
      "\(day.part1())" == ""
    )
  }

  @Test func testPart2() async throws {
    let day = DayTemplate(data: testData)
    #expect(
      "\(day.part2())" == ""
    )
  }
}
