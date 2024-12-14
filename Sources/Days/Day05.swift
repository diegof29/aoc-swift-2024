//
//  Day02.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation
import Parsing
@preconcurrency import RegexBuilder

private struct PageOrderingRuleParser: Parser {
  var body: some Parser<Substring, (Int, Int)> {
    Int.parser()
    "|"
    Int.parser()
  }
}

private struct RulesParser: Parser {
  var body: some Parser<Substring, [Int: [Int]]> {
    Many {
      PageOrderingRuleParser()
    } separator: {
      "\n"
    }
    .map { rules in
      let result: [Int: [Int]] = rules.reduce(
        into: [:],
        {
          let pagesAfer = $0[$1.0, default: []] + [$1.1]
          $0[$1.0] = pagesAfer
        })
      return result
    }
  }
}

private struct UpdateParser: Parser {
  var body: some Parser<Substring, [Int]> {
    Many {
      Int.parser()
    } separator: {
      ","
    }
  }
}

private struct UpdatesParser: Parser {
  var body: some Parser<Substring, [[Int]]> {
    Many {
      UpdateParser()
    } separator: {
      "\n"
    }
  }
}

struct Day05: AdventDay {

  fileprivate let orderingRules: [Int: [Int]]
  fileprivate let updates: [[Int]]

  init(data: String) throws {
    let input = data.split(separator: "\n\n")
    let orderingRulesInput = String(input[0])
    let updatesInput = String(input[1])

    self.orderingRules = try RulesParser().parse(orderingRulesInput)
    self.updates = try UpdatesParser().parse(updatesInput)
  }

  func isValid(update: [Int]) -> Bool {
    var visitedPages = Set<Int>()

    for page in update {
      let pageRules = (orderingRules[page] ?? [])
      if !pageRules.filter({ visitedPages.contains($0) }).isEmpty {
        return false
      } else {
        visitedPages.insert(page)
      }
    }

    return true
  }

  func fixedUpdate(update: [Int]) -> [Int] {
    var pagesToProcess = update
    var fixedUpdate: [Int] = []

    repeat {
      let page = pagesToProcess.removeFirst()
      if pagesToProcess.filter({ thisPage($0, goesBefore: page) }).isEmpty {
        /// Non of the remaining pages go before the one beign processed
        /// so it can be inserted in the fixedUpdate
        fixedUpdate.append(page)
      } else {
        /// Some page needs to go first, so this page will be processed later
        pagesToProcess.append(page)
      }

    } while !pagesToProcess.isEmpty

    return fixedUpdate
  }

  func thisPage(_ page: Int, goesBefore otherPage: Int) -> Bool {
    let pageRules = orderingRules[page] ?? []
    return pageRules.firstIndex(of: otherPage) != nil
  }

  func part1() -> Int {
    let validUpdates = updates.filter({ isValid(update: $0) })
    return validUpdates.reduce(0, { $0 + $1[($1.count - 1) / 2] })
  }

  func part2() -> Int {
    let fixedUpdates =
      updates
      .filter({ !isValid(update: $0) })
      .map({ fixedUpdate(update: $0) })
    return fixedUpdates.reduce(0, { $0 + $1[($1.count - 1) / 2] })
  }
}
