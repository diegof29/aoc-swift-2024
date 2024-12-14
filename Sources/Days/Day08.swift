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
  let map: Matrix
  let allAntennas: [Character: [Point]]

  init(data: String) throws {
    map = Matrix(data: data)
        
    self.allAntennas = map.reduce(into: [:], {
      guard $1.value != "." else { return }
      var antennas = $0[$1.value, default: []]
      antennas.append($1.position)
      $0[$1.value] = antennas
    })
  }
  
  func findAntinodes() -> [Point] {
    var antinodes = Set<Point>()
    for (_, anthenas) in allAntennas {
      let combinations = anthenas.combinations(ofCount: 2).map({ ($0[0], $0[1]) })
      for (first, second) in combinations {
        let vector = first.vector(second)
        
        let antinode1 = second + vector
        if map.isValid(position: antinode1) {
          antinodes.insert(antinode1)
        }
        
        let antinode2 = first + vector.rotated180
        if map.isValid(position: antinode2) {
          antinodes.insert(antinode2)
        }
      }
    }
    return Array(antinodes)
  }
  
  func findAntinodesNewModel() -> [Point] {
    var antinodes = Set<Point>()
    for (_, anthenas) in allAntennas {
      let combinations = anthenas.combinations(ofCount: 2).map({ ($0[0], $0[1]) })
      for (first, second) in combinations {
        let vector = first.vector(second).normalized
        var position = first
        repeat {
          antinodes.insert(position)
          position = position + vector
        } while map.isValid(position: position)
        
        let vector2 = vector.rotated180
        var position2 = first + vector2
        while map.isValid(position: position2) {
          antinodes.insert(position2)
          position2 = position2 + vector2
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
