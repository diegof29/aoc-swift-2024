//
//  Matrix.swift
//  AdventOfCode
//
//  Created by Diego Pais on 04.12.24.
//

struct Matrix: CustomStringConvertible {
  let rows: Int
  let columns: Int
  private(set) var data: [Character]
  
  init(data: String, separator: some RegexComponent = .newlineSequence) {
    let allRows = data.split(separator: separator)
    self.rows = allRows.count
    self.columns = allRows.first?.count ?? 0
    self.data = Array(allRows.joined())
  }
  
  init(rows: Int, columns: Int, defaultValue: Character) {
    self.rows = rows
    self.columns = columns
    self.data = Array(repeating: defaultValue, count: rows * columns)
  }
  
  init(rows: Int, columns: Int, data: [Character]) {
    assert(rows * columns == data.count)
    self.rows = rows
    self.columns = columns
    self.data = data
  }
  
  func isInBounds(from: Point, vector: Vector, length: Int = 1) -> Bool {
    let next = from.next(vector * length)
    return next.row >= 0 && next.row < rows && next.column >= 0 && next.column < columns
  }
  
  func isValid(position: Point) -> Bool {
    guard position.row >= 0 && position.row < rows else { return false }
    guard position.column >= 0 && position.column < columns else { return false }
    return position.row * columns + position.column < data.count
  }
  
  subscript (safe position: Point) -> Character? {
    guard isValid(position: position) else { return nil }
    return data[position.row * columns + position.column]
  }
  
  subscript (position: Point) -> Character {
    get { data[position.row * columns + position.column] }
    set { data[position.row * columns + position.column] = newValue }
  }
  
  var description: String {
    var output = ""
    for row in 0..<rows {
      for column in 0..<columns {
        output += "\(self[.init(row: row, column: column)])"
      }
      output += "\n"
    }
    return output
  }
}

extension Matrix {
  
  func position(from index: Int) -> Point {
    let row = index / columns
    return .init(row: row, column: index - (columns * row))
  }
    
  func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, (position: Point, value: Character)) -> Result) -> Result {
    data
      .enumerated()
      .reduce(initialResult) {
        nextPartialResult($0, (position: position(from: $1.offset), value: $1.element))
      }
  }
  
  func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, (position: Point, value: Character)) -> ()) -> Result {
    data
      .enumerated()
      .reduce(into: initialResult, {
        updateAccumulatingResult(&$0, (position: position(from: $1.offset), value: $1.element))
      })
  }

  func map<Result>(body: (_ post: Point, _ value: Character) -> Result) -> [Result] {
    return data.enumerated().map({ body(position(from: $0.offset), $0.element) })
  }
  
  func compactMap<Result>(body: (_ post: Point, _ value: Character) -> Result?) -> [Result] {
    return data.enumerated().compactMap({ body(position(from: $0.offset), $0.element) })
  }
  
  func forEach(body: (_ pos: Point, _ value: Character) -> Void) {
    return data.enumerated().forEach({ body(position(from: $0.offset), $0.element) })
  }
  
  func find(_ condition: (Point, Character) -> Bool ) -> (Point, Character)? {
    if let result = data.enumerated().first(where: { condition(position(from: $0.offset), $0.element) }) {
      return (position(from: result.offset), result.element)
    }
    return nil
  }
  
  func firstNonNil<Result>(_ body: (Point, Character) -> Result?) -> Result? {
    for row in 0..<rows {
      for column in 0...columns {
        let pos = Point(row: row, column: column)
        if let result = body(pos, self[pos]) {
          return result
        }
      }
    }
    return nil
  }
}
