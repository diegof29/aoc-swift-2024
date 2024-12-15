//
//  Day09.swift
//  AdventOfCode
//
//  Created by Diego Pais on 02.12.24.
//

import Algorithms
import Foundation

struct Day09: AdventDay {

  let input: [Int]

  init(data: String) throws {
    input = String(data).compactMap { Int("\($0)") }
    assert(input.count == data.count)
  }

  func filesChecksum(value: Int, startIndex: Int, blocks: Int) -> Int {
    let endIndex = startIndex + blocks - 1
    let sequenceSum = (Float(blocks) / 2.0) * Float(startIndex + endIndex)
    return value * Int(sequenceSum)
  }

  func part1() -> Int {
    guard input.count > 1 else { return 0 }
    var blocksInfo = input
    var checkSum = 0

    var leftValue = 1
    var rightValue = blocksInfo.count / 2
    var blockPosition = blocksInfo[0]

    while leftValue <= rightValue {

      // Fill free memory
      var freeBlocks = blocksInfo[leftValue * 2 - 1]
      var rightFileBlocks = blocksInfo[rightValue * 2]
      repeat {

        let blocksToTake = min(freeBlocks, rightFileBlocks)
        freeBlocks = freeBlocks - blocksToTake
        rightFileBlocks = rightFileBlocks - blocksToTake

        checkSum += filesChecksum(value: rightValue, startIndex: blockPosition, blocks: blocksToTake)
        blockPosition += blocksToTake

        if rightFileBlocks == 0 {
          rightValue -= 1
          rightFileBlocks = blocksInfo[rightValue * 2]
        } else {
          blocksInfo[rightValue * 2] = rightFileBlocks
        }
      } while freeBlocks > 0 && rightFileBlocks > 0

      // Process file
      let leftIndex = leftValue * 2
      let leftFileBlocks = blocksInfo[leftIndex]
      checkSum += filesChecksum(value: leftValue, startIndex: blockPosition, blocks: leftFileBlocks)
      blockPosition += leftFileBlocks

      leftValue += 1
    }

    return checkSum
  }

  func part2() -> Int {
    return 0
//    guard input.count > 1 else { return 0 }
//    let diskMap = input
//    var blockPositions: [Int: Int] = [:]
//    var currentBlock = 0
//    var freeMemory: [Int] = input.enumerated().reduce(into: []) {
//      if $1.offset % 2 != 0 && $1.element != 0 {
//        $0[$1.offset / 2] = $1.element
//        if $1.offset > 0 {
//          blockPositions[$1.offset] = currentBlock
//        }
//        currentBlock += $1.element
//      }
//    }
//
//    func consumeMemory(requiredMemory: Int) -> (mapIndex: Int, usedMemory: Int)? {
//      guard let memoryToUse = freeMemory.first(where: { $0 >= requiredMemory }) else { return nil }
//
//      var blocks = freeMemory[memoryToUse]
//      guard !blocks.isEmpty else { return nil }
//
//      let diskMapIndex = blocks.removeFirst()
//      if blocks.isEmpty {
//        freeMemory.removeValue(forKey: memoryToUse)
//      } else {
//        freeMemory[memoryToUse] = blocks
//      }
//
//      let originalMemoryForBlock = diskMap[diskMapIndex]
//      let memoryAlreadyConsumed = originalMemoryForBlock - memoryToUse
//      let leftSpace = originalMemoryForBlock - requiredMemory - memoryAlreadyConsumed
//      if leftSpace > 0 {
//        var blocksToUpdate = freeMemory[leftSpace, default: []]
//        blocksToUpdate.append(diskMapIndex)
//        freeMemory[leftSpace] = blocksToUpdate.sorted(by: <)
//      }
//
//      return (diskMapIndex, memoryAlreadyConsumed)
//    }
//
//    var checkSum = 0
//
//    var value = diskMap.count / 2
//
//    while value > 0 {
//      // Try to move file
//      let rightFileBlocks = diskMap[value * 2]
//      if let (diskMapIndex, usedMemory) = consumeMemory(requiredMemory: rightFileBlocks) {
//        let blockPosition = blockPositions[diskMapIndex]! + usedMemory
//        checkSum += filesChecksum(value: value, startIndex: blockPosition, blocks: rightFileBlocks)
//      } else {
//        let blockPosition = blockPositions[value * 2]!
//        checkSum += filesChecksum(value: value, startIndex: blockPosition, blocks: rightFileBlocks)
//      }
//
//      value -= 1
//    }
//
//    return checkSum
  }
}
