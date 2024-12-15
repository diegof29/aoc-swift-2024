//
//  Day09Tests.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Testing
@testable import AdventOfCode

struct Day09Tests {
  let testData = """
    2333133121414131402
    """

  @Test
  func testPart1() async throws {
    let challenge = try Day09(data: testData)
    #expect(String(describing: challenge.part1()) == "1928")
  }
  
  @Test
  func testPart2() async throws {
    let challenge = try Day09(data: testData)
    #expect(String(describing: challenge.part2()) == "0")
  }
}
