//
//  Matrix.swift
//  AdventOfCode
//
//  Created by Diego Pais on 04.12.24.
//

struct Matrix<T: Sendable>: CustomStringConvertible {
  struct Coordinate: CustomStringConvertible {
    let row: Int
    let column: Int
    var description: String { "(\(row), \(column))" }
    
    func next(_ direction: Direction, length: Int = 1) -> Coordinate {
      switch direction {
      case .forward: return .init(row: row, column: column + length)
      case .backwards: return .init(row: row, column: column - length)
      case .up: return .init(row: row - length, column: column)
      case .down: return .init(row: row + length, column: column)
      case .upForward: return .init(row: row - length, column: column + length)
      case .upBackward: return .init(row: row - length, column: column - length)
      case .downForward: return .init(row: row + length, column: column + length)
      case .downBackward: return .init(row: row + length, column: column - length)
      }
    }
  }
  
  enum Direction: CaseIterable {
    case forward
    case backwards
    case up
    case down
    case upForward
    case upBackward
    case downForward
    case downBackward
  }
  
  let rows: Int
  let columns: Int
  var data: [T]
  
  init(data: String, separator: some RegexComponent = .newlineSequence) where T == Character {
    let allRows = data.split(separator: separator)
    self.rows = allRows.count
    self.columns = allRows.first?.count ?? 0
    self.data = Array(allRows.joined())
  }
  
  init(rows: Int, columns: Int, defaultValue: T) {
    self.rows = rows
    self.columns = columns
    self.data = Array(repeating: defaultValue, count: rows * columns)
  }
  
  init(rows: Int, columns: Int, data: [T]) {
    assert(rows * columns == data.count)
    self.rows = rows
    self.columns = columns
    self.data = data
  }
  
  func isInBounds(from: Coordinate, direction: Direction, length: Int) -> Bool {
    let next = from.next(direction, length: length)
    return next.row >= 0 && next.row < rows && next.column >= 0 && next.column < columns
  }
  
  func isValid(position: Coordinate) -> Bool {
    guard position.row >= 0 && position.row < rows else { return false }
    guard position.column >= 0 && position.column < columns else { return false }
    return position.row * columns + position.column < data.count
  }
  subscript (safe position: Coordinate) -> T? {
    guard isValid(position: position) else { return nil }
    return data[position.row * columns + position.column]
  }
  
  subscript (position: Coordinate) -> T {
    get { data[position.row * columns + position.column] }
    set { data[position.row * columns + position.column] = newValue }
  }
  
  var description: String {
    var output = ""
    for row in 0..<rows {
      for column in 0..<columns {
        output += "\(self[.init(row: row, column: column)]) "
      }
      output += "\n"
    }
    return output
  }
}
