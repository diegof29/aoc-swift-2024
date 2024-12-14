//
//  Day10Tests.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Testing
@testable import AdventOfCode

struct Day10Tests {
  let testData = """
    """

  @Test
  func testPart1() async throws {
    let challenge = try Day10(data: testData)
    #expect(String(describing: challenge.part1()) == "14")
  }
  
  @Test
  func testPart2() async throws {
    let challenge = try Day10(data: testData)
    #expect(String(describing: challenge.part2()) == "34")
  }
}
