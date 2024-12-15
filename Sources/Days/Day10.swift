//
//  Day10.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation
import Parsing
@preconcurrency import RegexBuilder

struct Day10: AdventDay {
  
  let map: Matrix
  let trailHeads: [Point]
  
  init(data: String) throws {
    map = Matrix(data: data)
    trailHeads = map
      .reduce(into: [], {
        if $1.value == "0" {
          $0.append($1.position)
        }
      })
  }
  
  func canWalk(from: Point, to: Point) -> Bool {
    guard map.isValid(position: to) else { return false }
    let fromValue = Int("\(map[from])")!
    let toValue = Int("\(map[to])")!
    return toValue - fromValue == 1
  }
  
  func trailheadScore(point: Point, part2: Bool = false) -> Int {
    var visited = Set<Point>()
    var score = 0
    trailheadScore(point: point, score: &score, visited: &visited, part2: part2)
    return score
  }
  
  func trailheadScore(point: Point, score: inout Int, visited: inout Set<Point>, part2: Bool = false) {
    if !part2 {
      visited.insert(point)
    }
    if map[point] == "9"{
      score += 1
      return
    }
    
    let directions: [Vector] = [.down, .up, .forward, .backward]
    
    for direction in directions {
      let next = point.next(direction)
      if !visited.contains(next) && canWalk(from: point, to: next) {
        trailheadScore(point: next, score: &score, visited: &visited, part2: part2)
      }
    }
  }
  
  func part1() -> Int {
    return trailHeads.reduce(0, { $0 + trailheadScore(point: $1) })
  }

  func part2() -> Int {
    return trailHeads.reduce(0, { $0 + trailheadScore(point: $1, part2: true) })
  }
}
