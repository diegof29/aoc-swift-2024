//
//  Matrix+Vector.swift
//  AdventOfCode
//
//  Created by Diego Pais on 08.12.24.
//

struct Vector: CustomStringConvertible, Equatable, Hashable {
  
  enum Direction: String {
    case none, up, down, forward, backward, upForward, upBackward, downForward, downBackward
  }
  
  var dc: Int
  var dr: Int
  var direction: Direction
  
  static let up: Self = .init(dc: 0, dr: -1)
  static let down: Self = .init(dc: 0, dr: 1)
  static let forward: Self = .init(dc: 1, dr: 0)
  static let backward: Self = .init(dc: -1, dr: 0)
  static let upForward: Self = .init(dc: 1, dr: -1)
  static let upBackward: Self = .init(dc: -1, dr: -1)
  static let downForward: Self = .init(dc: 1, dr: 1)
  static let downBackward: Self = .init(dc: -1, dr: 1)
    
  init(dc: Int, dr: Int) {
    self.dc = dc
    self.dr = dr
   
    if dc == 0 && dr == 0 {
      self.direction = .none
    } else if dc == 0 {
      self.direction = dr < 0 ? .up : .down
    } else if dr == 0 {
      self.direction = dc > 0 ? .forward : .backward
    } else if dc > 0 {
      self.direction = dr < 0 ? .upForward : .downForward
    } else {
      self.direction = dr < 0 ? .upBackward : .downBackward
    }
  }
  
  func rotated90(clockwise: Bool = true) -> Vector {
    /// x2: cos 90 * X - sen 90 * Y
    /// y2: sen 90 * X + cos 90 * Y
    /// sen 90 = 1, sen -90 = -1
    /// cos 90 = 0
    return .init(dc: clockwise ? -dr : dr, dr: clockwise ? dc : -dc)
  }
  
  var rotated180: Vector {
    return .init(dc: -dc, dr: -dr)
  }
  
  var normalized: Vector {
    if dc >= dr, dc % dr == 0 {
      return .init(dc: dc / dr, dr: 1)
    } else if dr % dc == 0 {
      return .init(dc: 1, dr: dr / dc)
    }
    return .init(dc: dc, dr: dr)
  }
  
  var description: String {
    return "\(direction) - (dc: \(dc),dr: \(dr))"
  }
  
  static func * (left: Vector, right: Int) -> Vector {
    return .init(dc: left.dc * right, dr: left.dr * right)
  }
  
  static func + (left: Vector, right: Vector) -> Vector {
    return .init(dc: left.dc + right.dc, dr: left.dr + right.dr)
  }
}

