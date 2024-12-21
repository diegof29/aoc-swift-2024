//
//  Day14.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation
import Parsing

struct Robot: Hashable {
  var position: Point
  var velocity: Vector
}

struct RobotParser: Parser {
  var body: some Parser<Substring, Robot> {
    Parse {
      "p="
      Int.parser()
      ","
      Int.parser()
      " v="
      Int.parser()
      ","
      Int.parser()
    }.map({ Robot(
      position: .init(row: $1, column: $0),
      velocity: .init(dc: $2, dr: $3))
    })
  }
}

struct Day14: AdventDay {
  let robots: [Robot]
  let mapSize: (columns: Int, rows: Int)
  
  init(data: String) throws {
    mapSize = (101, 103)
    robots = try Many {
      RobotParser()
    } separator: {
      "\n"
    }.parse(data)
  }
  
  init(data: String, size: (Int, Int)) throws {
    mapSize = size
    robots = try Many {
      RobotParser()
    } separator: {
      "\n"
    }.parse(data)
  }
  
  func wrappedColumn(column: Int) -> Int {
    guard column != 0 else { return 0 }
    let module = column % (mapSize.columns)
    if module >= 0 {
      return module
    }
    return mapSize.columns - module * -1
  }
  
  func wrappedRow(row: Int) -> Int {
    guard row != 0 else { return 0 }
    let module = row % (mapSize.rows)
    if module >= 0 {
      return module
    }
    return mapSize.rows - module * -1
  }
  
  func wrappedPosition(_ position: Point) -> Point {
    Point(
      row: wrappedRow(row: position.row),
      column: wrappedColumn(column: position.column)
    )
  }
  
  func quadrantsCount(robots: [Robot]) -> (q1: Int, q2: Int, q3: Int, q4: Int) {
    var quadrant1 = 0
    var quadrant2 = 0
    var quadrant3 = 0
    var quadrant4 = 0
    
    robots.forEach {
      if $0.position.column < mapSize.columns / 2 {
        if $0.position.row < mapSize.rows / 2 {
          quadrant1 += 1
        } else if $0.position.row > mapSize.rows / 2 {
          quadrant3 += 1
        }
      } else if $0.position.column > mapSize.columns / 2 {
        if $0.position.row < mapSize.rows / 2 {
          quadrant2 += 1
        } else if $0.position.row > mapSize.rows / 2 {
          quadrant4 += 1
        }
      }
    }
    
    return (quadrant1, quadrant2, quadrant3, quadrant4)
  }
  
  func safetyValue(robots: [Robot]) -> Int {
    let (q1, q2, q3, q4) = quadrantsCount(robots: robots)
    return q1 * q2 * q3 * q4
  }
  
  func updatedRobots(seconds: Int) -> [Robot] {
    robots.map({
      let newPosition = $0.position + ($0.velocity * seconds)
      return Robot(
        position: wrappedPosition(newPosition),
        velocity: $0.velocity
      )
    })
  }
  
  func part1() -> Int {
    let updatedRobots = updatedRobots(seconds: 100)
    return safetyValue(robots: updatedRobots)
  }

  func map(from robots: [Robot]) -> Matrix {
    var map = Matrix(rows: mapSize.rows, columns: mapSize.columns, defaultValue: ".")
    robots.forEach({
      if map[$0.position] == "." {
        map[$0.position] = "1"
      } else if let digit = Int("\(map[$0.position])") {
        map[$0.position] = "\(digit + 1)".first!
      }
    })
    return map
  }
  
  func drawMap(robots: [Robot]) {
    print(map(from: robots))
  }
  
  func drawMap(seconds: Int) {
    let updatedRobots = updatedRobots(seconds: seconds)
    drawMap(robots: updatedRobots)
  }
  
  func part2() -> Int {
    let start = 1
    let totalSeconds = 10000
    var maxValue = 0
    var secondsMaxValue = 0

    for seconds in start ..< start + totalSeconds {
      
      let differentPositions = robots.reduce(into: Set<Point>(), {
        let newPosition = wrappedPosition($1.position + ($1.velocity * seconds))
        $0.insert(newPosition)
      }).count
      
      if differentPositions > maxValue {
        maxValue = differentPositions
        secondsMaxValue = seconds
      }
    }
    drawMap(seconds: secondsMaxValue)
        
    return secondsMaxValue
  }
}
