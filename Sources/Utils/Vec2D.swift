//
//  Vec2D.swift
//  AdventOfCode
//
//  Created by Diego Pais on 08.12.24.
//

struct Vec2D {
  var dx: Int
  var dy: Int
  
  var opposite: Vec2D {
    .init(dx: -dx, dy: -dy)
  }

  var normalized: Vec2D {
    if dx >= dy, dx % dy == 0 {
      return .init(dx: dx / dy, dy: 1)
    } else if dy % dx == 0 {
      return .init(dx: 1, dy: dy / dx)
    }
    return .init(dx: dx, dy: dy)
  }
}
