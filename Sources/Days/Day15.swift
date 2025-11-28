//
//  Day15.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation
import Parsing
@preconcurrency import RegexBuilder

enum Element: Character {
  case robot = "@"
  case rock = "O"
  case wall = "#"
  case empty = "."
  
  case rockStart = "["
  case rockEnd = "]"
}

struct Day15: AdventDay {
  
  let initialMap: Matrix
  let movements: [Vector]
  let initialRobot: Point
  
  init(data: String) throws {
    let input = data.split(separator: "\n\n")
    initialMap = Matrix(data: String(input[0]))
    movements = input[1].compactMap({
      switch $0 {
      case ">": return .forward
      case "<": return .backward
      case "^": return .up
      case "v": return .down
      default: return nil
      }
    })
    initialRobot = initialMap.find({ $1 == Element.robot.rawValue })!.0
  }
  
  func isElement(_ element: Element, _ position: Point, map: Matrix) -> Bool {
    return element.rawValue == map[position]
  }
  
  func isElement(_ element: Element, _ character: Character) -> Bool {
    element.rawValue == character
  }
  
  func updateRocks(point: Point, movement: Vector, map: inout Matrix) -> Bool {
    let newPosition = point + movement
    guard !isElement(.wall, newPosition, map: map) else { return false }
    
    if isElement(.rock, newPosition, map: map) && !updateRocks(point: newPosition, movement: movement, map: &map) {
      return false
    } else {
      map[point] = "."
      map[newPosition] = Element.rock.rawValue
      return true
    }
  }
    
  func updateMap(robot: inout Point, movement: Vector, map: inout Matrix) {
    let newPosition = robot + movement
    guard !isElement(.wall, newPosition, map: map) else { return }
    
    if isElement(.rock, newPosition, map: map) && !updateRocks(point: newPosition, movement: movement, map: &map) {
      return
    } else {
      map[robot] = "."
      map[newPosition] = Element.robot.rawValue
      robot = newPosition
    }
  }
  
  func rocksToMove(point: Point, movement: Vector, map: inout Matrix) -> [(Element, Point)] {
    
    guard let element = Element(rawValue: map[point]) else { return [] }
    
    let nextPosition = {
      if movement == .forward || movement == .backward {
        return point + (movement * 2)
      } else {
        return point + movement
      }
    }()
    
    guard !isElement(.wall, nextPosition, map: map) else { return [] }
    
    let nextIsRock = {
      isElement(.rockStart, nextPosition, map: map) || isElement(.rockEnd, nextPosition, map: map)
    }()
    
    if nextIsRock {
      
    } else {
      return [(element, point)]
    }
  }
  
  func updateScaledMap(robot: inout Point, movement: Vector, map: inout Matrix) {
    let newPosition = robot + movement

    let isRockStart = isElement(.rockStart, newPosition, map: map)
    let isRockEnd = isElement(.rockEnd, newPosition, map: map)
    
    let rocksToMove = rocksToMove(point: newPosition, movement: movement, map: &map)
    
    if isRockStart || isRockEnd {
      if rocksToMove.isEmpty {
        return
      } else {
          map[robot] = "."
          map[newPosition] = Element.robot.rawValue
          robot = newPosition
      }
    } else {
      map[robot] = "."
      map[newPosition] = Element.robot.rawValue
      robot = newPosition
    }
  }
  
  func rocks(map: Matrix) -> [Point] {
    return map.reduce(into: [], {
      if $1.value == Element.rock.rawValue {
        $0.append($1.position)
      }
    })
  }
  
  func scale(map: Matrix) -> Matrix {
    var scaledMap = Matrix(rows: map.rows, columns: map.columns * 2, defaultValue: ".")
    
    map.forEach { pos, value in
      let newPos = Point(row: pos.row, column: pos.column * 2)
      let newPosNext = newPos + .init(dc: 1, dr: 0)
      if isElement(.wall, value) {
        scaledMap[newPos] = "#"
        scaledMap[newPosNext] = "#"
      } else if isElement(.rock, value) {
        scaledMap[newPos] = "["
        scaledMap[newPosNext] = "]"
      } else if value == "." {
        scaledMap[newPos] = "."
        scaledMap[newPosNext] = "."
      } else if value == "@" {
        scaledMap[newPos] = "@"
      }
    }
    
    return scaledMap
  }
    
  func part1() -> Int {
    var map = initialMap
    var robot = initialRobot
    movements.forEach {
      updateMap(robot: &robot, movement: $0, map: &map)
    }

    print(map)
    return rocks(map: map).reduce(0, { $0 + ($1.row * 100 + $1.column) })
  }

  func part2() -> Int {
    var scaledMap = scale(map: initialMap)
    var robot = Point(row: initialRobot.row, column: initialRobot.column * 2)
    movements.forEach {
      updateMap(robot: &robot, movement: $0, map: &scaledMap, scaled: true)
    }
    print(scaledMap)
    return 0
  }
}

extension Vector {
  var arrow: String {
    if self == .up { return "^" }
    if self == .down { return "v" }
    if self == .forward { return">" }
    if self == .backward { return "<" }
    return "-"
  }
}
