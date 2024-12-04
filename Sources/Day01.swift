//
//  Day01.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Parsing

struct LocationsPairParser: Parser {
  var body: some Parser<Substring, (Int, Int)> {
    Int.parser()
    "   "
    Int.parser()
  }
}

struct AllLocationsParser: Parser {
  var body: some Parser<Substring, Locations> {
    Many {
      LocationsPairParser()
    } separator: {
      "\n"
    }
    .map({
      let lists: ([Int], [Int]) = $0.reduce(into: ([], [])) {
        $0.0.append($1.0)
        $0.1.append($1.1)
      }
      return Locations(left: lists.0, right: lists.1)
    })
  }
}

struct Locations {
  let left: [Int]
  let right: [Int]
}

struct Day01: AdventDay {
  let locations: Locations
  
  init(data: String) {
    self.locations = try! AllLocationsParser().parse(data)
  }
  
  func part1() async throws -> Int {
    let leftSorted = locations.left.sorted()
    let rightSorted = locations.right.sorted()
    
    return zip(leftSorted, rightSorted).reduce(0, { $0 + abs($1.0 - $1.1) })
  }
  
  func part2() async throws -> Int {
    let right: [Int: Int] = locations.right.reduce(into: [:]) {
      $0[$1, default: 0] += 1
    }
    return locations.left.reduce(0, {
      $0 + (right[$1, default: 0] * $1)
    })
  }
}
