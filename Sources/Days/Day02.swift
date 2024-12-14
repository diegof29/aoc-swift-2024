//
//  Day02.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Parsing

fileprivate struct Report {
  let levels: [Int]
}

fileprivate struct ReportParser: Parser {
  var body: some Parser<Substring, Report> {
    Many {
      Int.parser()
    } separator: {
      " "
    }
    .map{ Report(levels: $0) }
  }
}

struct Day02: AdventDay {
  var data: String
  fileprivate let reports: [Report]
  
  init(data: String) {
    self.data = data
    do {
      self.reports = try Many {
        ReportParser()
      } separator: {
        "\n"
      }
      .parse(data)
    } catch {
      print(error)
      self.reports = []
    }
  }
  
  fileprivate func isSafe(levels: [Int]) -> Bool {
    var levels = levels
    var lastLevel = levels.removeFirst()
    var lastDiff = 0
    
    repeat {
      let nextLevel = levels.removeFirst()
      let diff = nextLevel - lastLevel
      
      if diff == 0 { return false }
      if lastDiff != 0 && diff * lastDiff <= 0 { return false }
      if abs(diff) > 3 { return false }
      
      lastDiff = diff
      lastLevel = nextLevel

    } while !levels.isEmpty
    
    return true
  }
  
  func part1() -> Int {
    let validReports = reports.filter({ $0.levels.count > 1 })
    let safeReports = validReports.filter { isSafe(levels: $0.levels) }
    return safeReports.count
  }
  
  func part2() -> Int {
    let validReports = reports.filter({ $0.levels.count > 1 })
    let unsafeReports = validReports.filter { !isSafe(levels: $0.levels) }
    
    let rescuedReports = unsafeReports.filter {
      for i in 0..<$0.levels.count {
        var levels = $0.levels
        levels.remove(at: i)
        if isSafe(levels: levels) {
          return true
        }
      }
      return false
    }
    
    return validReports.count - (unsafeReports.count - rescuedReports.count)
  }
}
