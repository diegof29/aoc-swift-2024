//
//  Day02.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Parsing
@preconcurrency import RegexBuilder

let enableRef = Reference(Bool.self)
let leftRef = Reference(Int.self)
let rightRef = Reference(Int.self)

nonisolated(unsafe) let multiplicationPattern = Regex {
  "mul("
  TryCapture(as: leftRef) {
    OneOrMore(.digit)
  } transform: { Int($0) }
  ","
  TryCapture(as: rightRef) {
    OneOrMore(.digit)
  } transform: { Int($0) }
  ")"
}

nonisolated(unsafe) let instructionsPattern = Regex {
  Capture(as: enableRef) {
    ChoiceOf {
      "do"
      "don't"
    }
  } transform: { value in value == "do" ? true : false }
  "()"
}

nonisolated(unsafe) let memoryPattern = Regex {
  ChoiceOf {
    instructionsPattern
    multiplicationPattern
  }
}

struct Day03: AdventDay {
  var data: String
  
  init(data: String) {
    self.data = data
  }
  
  func part1() -> Int {
    return data
      .matches(of: multiplicationPattern)
      .reduce(0, { $0 + ($1[leftRef] * $1[rightRef]) })
  }
  
  func part2() -> Int {
    var enabled = true
    return data
      .matches(of: memoryPattern)
      .reduce(0, {
        if let isEnabled = $1.output.1 {
          enabled = isEnabled
          return $0
        }
        if enabled {
          return $0 + ($1[leftRef] * $1[rightRef])
        }
        return $0
      })
  }
}
