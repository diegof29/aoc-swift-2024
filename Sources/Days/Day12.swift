//
//  Day12.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation
import Parsing
@preconcurrency import RegexBuilder

struct Day12: AdventDay {
  
  let garden: Matrix
  let plants: Set<Character>
  
  init(data: String) throws {
    garden = Matrix(data: data)
    plants = garden.reduce(into: Set<Character>(), {
      $0.insert($1.value)
    })
  }
  
  func isValid(position: Point, plant: Character) -> Bool {
    guard garden.isValid(position: position) else { return false }
    return garden[position] == plant
  }
  
  func region(plant: Character, position: Point, visited: inout Set<Point>) -> [Point] {
    guard isValid(position: position, plant: plant) && !visited.contains(position) else { return [] }
    
    visited.insert(position)
    
    let directions: [Vector] = [.down, .up, .forward, .backward]
    
    return [position] + directions.reduce(into: [], {
      $0.append(contentsOf: region(plant: plant, position: position.next($1), visited: &visited))
    })
  }
  
  func nextStartPosition(plant: Character, visited: Set<Point>) -> Point? {
    garden.find({ $1 == plant && !visited.contains($0) })?.0
  }
  
  func loadRegions(plant: Character) -> [[Point]] {
    var visited = Set<Point>()
    
    var regions: [[Point]] = []
    while let start = nextStartPosition(plant: plant, visited: visited) {
      let region: [Point] = region(plant: plant, position: start, visited: &visited)
      regions.append(region)
    }
    
    return regions
  }
  
  func perimeter(point: Point) -> Int {
    let plant = garden[point]
    let directions: [Vector] = [.down, .up, .forward, .backward]
    return directions.reduce(0, { $0 + (isValid(position: point.next($1), plant: plant) ? 0 : 1) })
  }
  
  func isFense(point: Point, directions: [Vector]) -> Bool {
    let plant = garden[point]
    return directions.contains(where: { !isValid(position: point.next($0), plant: plant) })
  }
  
  func perimeter(region: [Point]) -> Int {
    region.reduce(0, { $0 + perimeter(point: $1) })
  }
    
  func sides(region: [Point]) -> Int {
    let directions: [Vector] = [.up, .down, .backward, .forward]
    return directions.reduce(0, { allSides, direction in
      let fenses = region.filter{( isFense(point: $0, directions: [direction] ) )}
      let grouped = fenses.grouped(by: { direction.isVertical ? $0.row : $0.column })
      return allSides + grouped.reduce(0, {
        let sorted = $1.value.sorted(using: KeyPathComparator(direction.isVertical ? \.column : \.row))
        var sides = 1
        var prevPoint: Point?
        for point in sorted {
          if let prevPoint {
            let diff = direction.isVertical ? point.column - prevPoint.column : point.row - prevPoint.row
            if diff != 1 {
              sides += 1
            }
          }
          prevPoint = point
        }
        return $0 + sides
      })
    })
  }
  
  func regionScore(region: [Point], part1: Bool = true) -> Int {
    let area = region.count
    if part1 {
      return perimeter(region: region) * area
    }
    return sides(region: region) * area
  }
  
  func regionsScore(regions: [[Point]], part1: Bool = true) -> Int {
    return regions.reduce(0, { $0 + regionScore(region: $1, part1: part1) })
  }
  
  func part1() -> Int {
    let allRegions: [[[Point]]] = plants.reduce(into: [], {
      $0.append(loadRegions(plant: $1))
    })
    return allRegions.reduce(0, { $0 + regionsScore(regions: $1) })
  }

  func part2() -> Int {
    let allRegions: [[[Point]]] = plants.reduce(into: [], {
      $0.append(loadRegions(plant: $1))
    })
    return allRegions.reduce(0, { $0 + regionsScore(regions: $1, part1: false) })
  }
}

extension Vector {
  var isVertical: Bool {
    return self == .up || self == .down
  }
}
