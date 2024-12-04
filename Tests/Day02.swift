//
//  Day02.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Testing
@testable import AdventOfCode

struct Day02Tests {
  @Test
  func testPart1() async throws {
    
    let testData = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """
    
    let challenge = Day02(data: testData)
    
    #expect(String(describing: challenge.part1()) == "2")
  }
}
