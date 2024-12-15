//
//  Day11Tests.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Testing
@testable import AdventOfCode

struct Day11Tests {
  let testData = """
    125 17
    """

  @Test
  func testPart1() async throws {
    let challenge = try Day11(data: testData)
    #expect(String(describing: challenge.part1()) == "55312")
  }
  
  @Test
  func testPart2() async throws {
    let challenge = try Day11(data: testData)
    #expect(String(describing: challenge.part2()) == "65601038650482")
  }
}
