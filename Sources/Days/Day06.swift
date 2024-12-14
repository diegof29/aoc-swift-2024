//
//  Day06.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation
import Parsing
@preconcurrency import RegexBuilder

struct Day06: AdventDay {
  
  struct Guard: Hashable, CustomStringConvertible {
    var position: Point
    var direction: Vector
    
    init(position: Point, direction: Vector) {
      self.position = position
      self.direction = direction
    }
    
    init?(character: Character, position: Point) {
      self.position = position
      if character == ">" {
        self.direction = .forward
      } else if character == "^" {
        self.direction = .up
      } else if character == "<" {
        self.direction = .backward
      } else if character == "V" {
        self.direction = .down
      } else {
        return nil
      }
    }
    
    func nextPosition() -> Point {
      return position.next(direction)
    }
    
    mutating func walk() {
      position = position.next(direction)
    }
    
    mutating func rotate() {
      direction = direction.rotated90()
    }
    
    var description: String {
      let directionChar = {
        switch direction {
        case .up: return "^"
        case .down: return "V"
        case .forward: return ">"
        case .backward: return "<"
        default: return "-"
        }
      }()
      return "(\(position.row), \(position.column)) \(directionChar)"
    }
  }
  
  let map: Matrix
  
  init(data: String) throws {
    map = Matrix(data: data)
  }

  func findGuard() -> Guard? {
    map.firstNonNil({ Guard(character: $1, position: $0) })
  }
  
  func visitedPositions(theGuard initGuard: Guard) -> [Point] {
    var theGuard = initGuard
    var visitedPositions = Set<Point>([theGuard.position])
    
    repeat {
      let nextPosition = theGuard.nextPosition()
      if map[nextPosition] == "#" {
        theGuard.rotate()
      } else {
        theGuard.walk()
        visitedPositions.insert(theGuard.position)
      }
    } while map.isInBounds(from: theGuard.position, vector: theGuard.direction)
    
    
    return Array(visitedPositions)
  }
  
  func isLoop(theGuard input: Guard, obstruction: Point) -> Bool {
    var theGuard = input
    var ghosts = Set<Guard>([theGuard])
    
    repeat {
      let nextPosition = theGuard.nextPosition()
      if map[nextPosition] == "#" || nextPosition == obstruction {
        theGuard.rotate()
        if ghosts.contains(theGuard) {
          return true
        }
      } else {
        theGuard.walk()
      }
      ghosts.insert(theGuard)
    } while map.isInBounds(from: theGuard.position, vector: theGuard.direction)
    return false
  }

  func part1() -> Int {
    guard let theGuard = findGuard() else {
      print("Could not find the guard")
      return 0
    }
    return visitedPositions(theGuard: theGuard).count
  }

  func part2() -> Int {
    guard let theGuard = findGuard() else {
      print("Could not find the guard")
      return 0
    }
    return visitedPositions(theGuard: theGuard)
      .reduce(0, { $0 + (isLoop(theGuard: theGuard, obstruction: $1) ? 1 : 0) })
  }
}
