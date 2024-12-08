//
//  Matrix.swift
//  AdventOfCode
//
//  Created by Diego Pais on 04.12.24.
//

struct Matrix<T: Sendable>: CustomStringConvertible {
  struct Coordinate: CustomStringConvertible, Equatable, Hashable {
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
    
    func vector(_ to: Coordinate) -> Vec2D {
      return .init(dx: to.row - row, dy: to.column - column)
    }
    
    func adding(_ vec: Vec2D) -> Coordinate {
      return .init(row: row + vec.dx, column: column + vec.dy)
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
    
    func rotated90(clockwise: Bool = true) -> Direction {
      switch self {
      case .forward: return clockwise ? .down : .up
      case .backwards: return clockwise ? .up : .down
      case .up: return clockwise ? .forward : .backwards
      case .down: return clockwise ? .backwards : .forward
      case .upForward: return clockwise ? .downForward : .upBackward
      case .upBackward: return clockwise ? .upForward : .downBackward
      case .downForward: return clockwise ? .downBackward : .upForward
      case .downBackward: return clockwise ? .upBackward : .downForward
      }
    }
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
  
  func forEach(body: (_ pos: Coordinate, _ value: T) -> Void) {
    for row in 0..<rows {
      for column in 0..<columns {
        let pos = Coordinate(row: row, column: column)
        body(pos, self[pos])
      }
    }
  }
  
  func find(_ condition: (Coordinate, T) -> Bool ) -> (Coordinate, T)? {
    for row in 0..<rows {
      for column in 0...columns {
        let pos = Coordinate(row: row, column: column)
        if condition(pos, self[pos]) {
          return (pos, self[pos])
        }
      }
    }
    return nil
  }
  
  func firstNonNil<Result>(_ body: (Coordinate, T) -> Result?) -> Result? {
    for row in 0..<rows {
      for column in 0...columns {
        let pos = Coordinate(row: row, column: column)
        if let result = body(pos, self[pos]) {
          return result
        }
      }
    }
    return nil
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
