//
//  Day07.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation
import Parsing
@preconcurrency import RegexBuilder

private struct Equation {
  let result: Int
  let values: [Int]
}

private struct EquationParser: Parser {
  var body: some Parser<Substring, Equation> {
    Parse(Equation.init) {
      Int.parser()
      ": "
      Many {
        Int.parser()
      } separator: {
        " "
      }
    }
  }
}

struct Day07: AdventDay {
  
  fileprivate let equations: [Equation]
  
  enum Operation: CaseIterable, CustomStringConvertible {
    case add
    case multiply
    case concat
    
    var description: String {
      switch self {
      case .add: "+"
      case .multiply: "*"
      case .concat: "||"
      }
    }
    
    func eval(left: Int, right: Int) -> Int {
      switch self {
      case .add: return left + right
      case .multiply: return left * right
      case .concat: return Int("\(left)\(right)") ?? 0
      }
    }
  }
  
  init(data: String) throws {
    equations = try Many { EquationParser() } separator: {
      "\n"
    }
    .parse(data)
  }

  fileprivate func eval(value: Int, result: Int, values: [Int], operations: [Operation]) -> Bool {
    if value > result { return false }
    if values.isEmpty { return value == result }
    var newValues = values
    let nextValue = newValues.removeFirst()
    
    for operation in operations {
      if eval(
        value: operation.eval(left: value, right: nextValue),
        result: result,
        values: newValues,
        operations: operations
      ) {
        return true
      }
    }
    return false
  }
  
  fileprivate func isValid(_ equation: Equation, operations: [Operation]) -> Bool {
    var values = equation.values
    let isValid = eval(
      value: values.removeFirst(),
      result: equation.result,
      values: values,
      operations: operations
    )
    return isValid
  }

  func part1() -> Int {
    return equations.reduce(0, { $0 + (isValid($1, operations: [.add, .multiply]) ? $1.result : 0)})
  }

  func part2() -> Int {
    return equations.reduce(0, { $0 + (isValid($1, operations: [.add, .multiply, .concat]) ? $1.result : 0)})
  }
}
