//
//  Day02.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Parsing
@preconcurrency import RegexBuilder

struct Day04: AdventDay {
  typealias Coordinate = Matrix<Character>.Coordinate
  typealias Direction = Matrix<Character>.Direction
  
  let matrix: Matrix<Character>
  let word: [Character] = ["X", "M", "A", "S"]
  
  init(data: String) {
    matrix = Matrix(data: data)
  }
  
  func containsWord(direction: Direction, position: Coordinate) -> Bool {
    guard matrix.isInBounds(from: position, direction: direction, length: word.count - 1) else {
      return false
    }
    
    var word = word
    word.removeFirst()
    var nextPosition = position
    repeat {
      nextPosition = nextPosition.next(direction)
      if matrix[nextPosition] != word.removeFirst() {
        return false
      }
    } while !word.isEmpty
    return true
  }
  
  func wordOccurrences(position: Coordinate) -> Int {
    var word = word
    guard matrix[position] == word.removeFirst() else { return 0 }
    let count = Direction.allCases.reduce(0) {
      $0 + (containsWord(direction: $1, position: position) ? 1 : 0)
    }
    return count
  }
  
  func patternOccurrences(position: Coordinate) -> Int {
    guard matrix[position] == "A" else { return 0 }
    
    let topLeft = position.next(.upBackward)
    let topRight = position.next(.upForward)
    let bottomLeft = position.next(.downBackward)
    let bottomRight = position.next(.downForward)
    
    let first = matrix[topLeft] == "M" && matrix[bottomRight] == "S" || matrix[topLeft] == "S" && matrix[bottomRight] == "M"
    let second = matrix[topRight] == "M" && matrix[bottomLeft] == "S" || matrix[topRight] == "S" && matrix[bottomLeft] == "M"
    
    return first && second ? 1 : 0
  }
  
  func part1() -> Int {
    var count = 0
    for row in 0..<matrix.rows {
      for column in 0..<matrix.columns {
        count += wordOccurrences(position: .init(row: row, column: column))
      }
    }
    return count
  }
  
  func part2() -> Int {
    var count = 0
    for row in 1..<matrix.rows - 1 {
      for column in 1..<matrix.columns - 1 {
        count += patternOccurrences(position: .init(row: row, column: column))
      }
    }
    return count
  }
}
