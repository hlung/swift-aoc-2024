import ArgumentParser
import Foundation

private let allChallenges: [any AdventDay] = {
  let fileManager = FileManager.default
  let currentPath = fileManager.currentDirectoryPath
  let newCodeFilePath = "\(currentPath)/Sources"
  let codeFiles = try! fileManager.contentsOfDirectory(atPath: currentPath).filter({ $0.hasPrefix("Day") && $0 != "DayN" })
  let namespace = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""

  return codeFiles.map { file in
    let className = file.split(separator: "/").last!
    let myClass = NSClassFromString("\(namespace).\(className)") as! any AdventDay.Type
    return myClass.init()
  }
}()

@main
struct AdventOfCode: AsyncParsableCommand {
  @Argument(help: "The day of the challenge. For December 1st, use '1'.")
  var day: Int?

  @Argument(help: "Create a set of files for a new day challenge")
  var newday: String? = nil

  @Flag(help: "Benchmark the time taken by the solution")
  var benchmark: Bool = false

  @Flag(help: "Run all the days available")
  var all: Bool = false

  /// The selected day, or the latest day if no selection is provided.
  var selectedChallenge: any AdventDay {
    get throws {
      if let day {
        if let challenge = allChallenges.first(where: { $0.day == day }) {
          return challenge
        } else {
          throw ValidationError("No solution found for day \(day)")
        }
      } else {
        return latestChallenge
      }
    }
  }

  /// The latest challenge in `allChallenges`.
  var latestChallenge: any AdventDay {
    allChallenges.max(by: { $0.day < $1.day })!
  }

  func run<T>(part: () async throws -> T, named: String) async -> Duration {
    var result: Result<T, Error>?
    let timing = await ContinuousClock().measure {
      do {
        result = .success(try await part())
      } catch {
        result = .failure(error)
      }
    }
    switch result! {
    case .success(let success):
      print("\(named): \(success)")
    case .failure(let failure as PartUnimplemented):
      print("Day \(failure.day) part \(failure.part) unimplemented")
    case .failure(let failure):
      print("\(named): Failed with error: \(failure)")
    }
    return timing
  }

  func run() async throws {
    if let day = self.newday {
      try runNewDay(day: day)
      return
    }

    let challenges =
      if all {
        allChallenges
      } else {
        try [selectedChallenge]
      }

    for challenge in challenges {
      print("Executing Advent of Code challenge \(challenge.day)...")

      let timing1 = await run(part: challenge.part1, named: "Part 1")
      let timing2 = await run(part: challenge.part2, named: "Part 2")

      if benchmark {
        print("Benchmark:")
        print("Part 1 took \(timing1)")
        print("Part 2 took \(timing2)")
        #if DEBUG
          print("Looks like you're benchmarking debug code. Try swift run -c release")
        #endif
      }
    }
  }

  private func runNewDay(day: String) throws {
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath

    // Data
    let newDataFilePath = "\(currentPath)/Sources/Data/Day\(day).swift"
    fileManager.createFile(atPath: newDataFilePath, contents: nil)
    print("Created \(newDataFilePath)")

    // Code
    let oldCodeFilePath = "\(currentPath)/Sources/DayN.swift"
    let newCodeFilePath = "\(currentPath)/Sources/Day\(day).swift"
    guard !fileManager.fileExists(atPath: newCodeFilePath) else {
      fatalError("File already exists at \(newCodeFilePath).")
    }

    try String(contentsOfFile: oldCodeFilePath, encoding: .utf8)
      .replacingOccurrences(of: "DayN", with: "Day\(day)")
      .write(toFile: newCodeFilePath, atomically: true, encoding: .utf8)
    print("Created \(newCodeFilePath)")

    // Test
    let oldTestFilePath = "\(currentPath)/Sources/Tests/DayN.swift"
    let newTestFilePath = "\(currentPath)/Sources/Tests/Day\(day).swift"
    guard !fileManager.fileExists(atPath: newTestFilePath) else {
      fatalError("File already exists at \(newTestFilePath).")
    }
    try String(contentsOfFile: oldTestFilePath, encoding: .utf8)
      .replacingOccurrences(of: "DayN", with: "Day\(day)")
      .write(toFile: newTestFilePath, atomically: true, encoding: .utf8)
    print("Created \(newTestFilePath)")
  }

}
