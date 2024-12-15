//
//  Day11.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation
import Parsing

private struct StonesParser: Parser {
  var body: some Parser<Substring, [Int]> {
    Many {
      Int.parser()
    } separator: {
      " "
    }
  }
}

struct Day11: AdventDay {
  
  let initialStones: [Int]
  
  init(data: String) throws {
    initialStones = try StonesParser().parse(data)
  }

  func blink(stone: Int) -> [Int] {
    let stoneStr = "\(stone)"
    if stone == 0 {
      return [1]
    } else if stoneStr.count % 2 == 0 {
      let first = Int(stoneStr[stoneStr.startIndex..<stoneStr.index(stoneStr.startIndex, offsetBy: stoneStr.count / 2)])!
      let second = Int(stoneStr[stoneStr.index(stoneStr.startIndex, offsetBy: stoneStr.count / 2)..<stoneStr.endIndex])!
      return [first, second]
    } else {
      return [stone * 2024]
    }
  }

  func simulateBlinks(stone: Int, blinks: Int, cache: inout [String: Int]) -> Int {
    let stones = blink(stone: stone)
    if blinks == 1 {
      return stones.count
    }
    
    if let value = cache["\(stone)-\(blinks)"] {
      return value
    }

    let result = stones.reduce(0, { $0 + simulateBlinks(stone: $1, blinks: blinks - 1, cache: &cache) })
    cache["\(stone)-\(blinks)"] = result
    return result
  }
  
  func part1() -> Int {
    var cache: [String: Int] = [:]
    let result = initialStones.reduce(0, { $0 + simulateBlinks(stone: $1, blinks: 25, cache: &cache) })
    return result
  }

  func part2() -> Int {
    var cache: [String: Int] = [:]
    let result = initialStones.reduce(0, { $0 + simulateBlinks(stone: $1, blinks: 75, cache: &cache) })
    return result
  }
}
