//
//  Point.swift
//  AdventOfCode
//
//  Created by Diego Pais on 08.12.24.
//

struct Point: CustomStringConvertible, Equatable, Hashable {
  let row: Int
  let column: Int
  var description: String { "(\(column), \(row))" }
  
  static let zero: Point = .init(row: 0, column: 0)
  
  func next(_ vector: Vector) -> Point {
    return .init(row: row + vector.dr, column: column + vector.dc)
  }
  
  func vector(_ to: Point) -> Vector {
    return .init(dc: to.column - column, dr: to.row - row)
  }
  
  static func + (left: Point, right: Vector) -> Point {
    return .init(row: left.row + right.dr, column: left.column + right.dc)
  }
}

