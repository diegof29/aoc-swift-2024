//
//  Day13.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation
import Parsing
import Collections

struct Game: CustomStringConvertible {
  var buttonA: Vector
  var buttonB: Vector
  var prize: Point
  
  var description: String {
    return """
    ButtonA -> \(buttonA)
    ButtonB -> \(buttonB)
    Prize -> \(prize)
    """
  }
}

struct ButtonParser: Parser {
  let button: String
  var body: some Parser<Substring, Vector> {
    Parse(Vector.init) {
      "Button \(button): X+"
      Int.parser()
      ", Y+"
      Int.parser()
      "\n"
    }
  }
}

struct PrizeParser: Parser {
  var body: some Parser<Substring, Point> {
    Parse {
      "Prize: X="
      Int.parser()
      ", Y="
      Int.parser()
    }.map { Point(row: $1, column: $0) }
  }
}

struct GameParser: Parser {
  var body: some Parser<Substring, Game> {
    Parse(Game.init) {
      ButtonParser(button: "A")
      ButtonParser(button: "B")
      PrizeParser()
    }
  }
}

struct GamesParser: Parser {
  var body: some Parser<Substring, [Game]> {
    Many {
      GameParser()
    } separator: {
      "\n\n"
    }
  }
}

struct Move: Comparable {
  static func < (lhs: Move, rhs: Move) -> Bool {
    return lhs.cost < rhs.cost
  }
  let position: Point
  let cost: Int
}

struct Day13: AdventDay {
  
  let games: [Game]
  
  init(data: String) throws {
    games = try GamesParser().parse(data)
  }
  
  func requiredAPushesToWin(game: Game, part1: Bool = true) -> Int? {
    let top = game.prize.row * game.buttonB.dc - game.prize.column * game.buttonB.dr
    let bottom = game.buttonA.dr * game.buttonB.dc - game.buttonA.dc * game.buttonB.dr
    
    if bottom == 0 { return nil }
    
    let pushes = Double(top) / Double(bottom)
    
    if floor(pushes) == pushes {
      if part1 {
        return pushes <= 100 ? Int(pushes) : nil
      }
      return Int(pushes)
    }
      
    return nil
  }
  
  func requiredBPushesToWin(game: Game, aPushes: Int, part1: Bool = true) -> Int? {
    guard game.buttonB.dc != 0 else { return nil }
    let top = (game.prize.column - aPushes * game.buttonA.dc)
    let pushes = Double(top) / Double(game.buttonB.dc)
    
    if floor(pushes) == pushes {
      if part1 {
        return pushes <= 100 ? Int(pushes) : nil
      }
      return Int(pushes)
    }
    
    return nil
  }
  
  func requiredTokensToWin(game: Game, part1: Bool = true) -> Int? {
    guard let aPushes = requiredAPushesToWin(game: game, part1: part1) else { return  nil }
    guard let bPushes = requiredBPushesToWin(game: game, aPushes: aPushes, part1: part1) else { return nil }
    
    return aPushes * 3 + bPushes
  }
  
  func part1() -> Int {
    return games.compactMap({ requiredTokensToWin(game: $0) }).reduce(0, +)
  }

  func part2() -> Int {
    return games
      .map(
        {
          Game(
            buttonA: $0.buttonA,
            buttonB: $0.buttonB,
            prize: .init(row: $0.prize.row + 10_000_000_000_000, column: $0.prize.column + 10_000_000_000_000)
          )
        })
      .compactMap({ requiredTokensToWin(game: $0, part1: false) }).reduce(0, +)
  }
}
