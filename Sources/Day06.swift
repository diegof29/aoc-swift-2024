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
  typealias Map = Matrix<Character>
  typealias Coordinate = Map.Coordinate
  typealias Direction = Map.Direction
  
  struct Guard: Hashable, CustomStringConvertible {
    var position: Coordinate
    var direction: Direction
    
    init(position: Coordinate, direction: Direction) {
      self.position = position
      self.direction = direction
    }
    
    init?(character: Character, position: Coordinate) {
      self.position = position
      if character == ">" {
        self.direction = .forward
      } else if character == "^" {
        self.direction = .up
      } else if character == "<" {
        self.direction = .backwards
      } else if character == "V" {
        self.direction = .down
      } else {
        return nil
      }
    }
    
    func nextPosition() -> Coordinate {
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
        case .backwards: return "<"
        default: return "-"
        }
      }()
      return "(\(position.row), \(position.column)) \(directionChar)"
    }
  }
  
  let map: Matrix<Character>
  
  init(data: String) throws {
    map = Matrix(data: data)
  }

  func findGuard() -> Guard? {
    map.firstNonNil({ Guard(character: $1, position: $0) })
  }
  
  func visitedPositions(theGuard initGuard: Guard) -> [Coordinate] {
    var theGuard = initGuard
    var visitedPositions = Set<Coordinate>([theGuard.position])
    
    repeat {
      let nextPosition = theGuard.nextPosition()
      if map[nextPosition] == "#" {
        theGuard.rotate()
      } else {
        theGuard.walk()
        visitedPositions.insert(theGuard.position)
      }
    } while map.isInBounds(from: theGuard.position, direction: theGuard.direction, length: 1)
    
    return Array(visitedPositions)
  }
  
  func isLoop(theGuard input: Guard, obstruction: Coordinate) -> Bool {
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
    } while map.isInBounds(from: theGuard.position, direction: theGuard.direction, length: 1)
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
