//
//  Day14Tests.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Testing
@testable import AdventOfCode

struct Day14Tests {
  let testData = """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """

  @Test
  func testPart1() async throws {
    let challenge = try Day14(data: testData, size: (11, 7))
    #expect(String(describing: challenge.part1()) == "12")
  }
  
  @Test
  func testPart2() async throws {
    let challenge = try Day14(data: testData, size: (11, 7))
    #expect(String(describing: challenge.part2()) == "23")
  }
  
  @Test(
    "Wrapped columns",
    arguments: [(0, 0), (8, 8), (11, 0), (13, 2), (22, 0), (37, 4), (-11, 0), (-2, 9), (-14, 8)]
  )
  func testWrappedColumn(column: Int, expectedColumn: Int) async throws {
    let challenge = try Day14(data: testData, size: (11, 7))
    #expect(challenge.wrappedColumn(column: column) == expectedColumn)
  }
  
  @Test(
    "Wrapped rows",
    arguments: [(0, 0), (5, 5), (7, 0), (10, 3), (14, 0), (27, 6), (-294, 0), (-1, 6), (-10, 4)]
  )
  func testWrappedRow(row: Int, expectedRow: Int) async throws {
    let challenge = try Day14(data: testData, size: (11, 7))
    #expect(challenge.wrappedRow(row: row) == expectedRow)
  }
}
