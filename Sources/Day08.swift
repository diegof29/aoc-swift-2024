//
//  Day08.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation
import Parsing
@preconcurrency import RegexBuilder

struct Day08: AdventDay {
  typealias Map = Matrix<Character>
  typealias Coordinate = Map.Coordinate
  typealias Direction = Map.Direction
  
  let map: Map
  let allAnthenas: [Character: [Coordinate]]

  init(data: String) throws {
    map = Matrix(data: data)
    
    var anthenas: [Character: [Coordinate]] = [:]
    map.forEach(body: { pos, value in
      guard value != "." else { return }
      var frequencyAnthenas = anthenas[value, default: []]
      frequencyAnthenas.append(pos)
      anthenas[value] = frequencyAnthenas
    })
    self.allAnthenas = anthenas
  }
  
  func findAntinodes() -> [Coordinate] {
    var antinodes = Set<Coordinate>()
    for (_, anthenas) in allAnthenas {
      let combinations = anthenas.combinations(ofCount: 2).map({ ($0[0], $0[1]) })
      for (first, second) in combinations {
        let vector = first.vector(second)
        
        let antinode1 = second.adding(vector)
        if map.isValid(position: antinode1) {
          antinodes.insert(antinode1)
        }
        
        let antinode2 = first.adding(vector.opposite)
        if map.isValid(position: antinode2) {
          antinodes.insert(antinode2)
        }
      }
    }
    return Array(antinodes)
  }
  
  func findAntinodesNewModel() -> [Coordinate] {
    var antinodes = Set<Coordinate>()
    for (_, anthenas) in allAnthenas {
      let combinations = anthenas.combinations(ofCount: 2).map({ ($0[0], $0[1]) })
      for (first, second) in combinations {
        let vector = first.vector(second).normalized
        var position = first
        repeat {
          antinodes.insert(position)
          position = position.adding(vector)
        } while map.isValid(position: position)
        
        let vector2 = vector.opposite
        var position2 = first.adding(vector2)
        while map.isValid(position: position2) {
          antinodes.insert(position2)
          position2 = position2.adding(vector2)
        }
      }
    }
    return Array(antinodes)
  }
  
  func part1() -> Int {
    return findAntinodes().count
  }

  func part2() -> Int {
    return findAntinodesNewModel().count
  }
}
