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
      "\(day.part2())" == "2858"
    )
  }

  @Test func testPart1Extra1() async throws {
    let day = Day09(data: "2333133121414161402")
    #expect(
      "\(day.part1())" == "2515"
    )
  }

  @Test func testPart1Extra2() async throws {
    #expect(
      "\(Day09(data: "111111111").part1())" == "23"
    )
    #expect(
      "\(Day09(data: "011111111").part1())" == "13"
    )
    #expect(
      "\(Day09(data: "011011111").part1())" == "14"
    )
    #expect(
      "\(Day09(data: "101000011011").part1())" == "23"
    )
  }

  @Test func testPart2Extra1() async throws {
    #expect(
      "\(Day09(data: "10120301214").part2())" == "123"
    )
  }
}
