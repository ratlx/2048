//
//  Game.swift
//  2048
//
//  Created by 小火锅 on 2025/3/6.
//

import Foundation

var width: Int = 4                  // col (列)
var height: Int = 4                 // row (行)
let initTilesAmount = 2

@Observable
class Game {
    var valueBoard: [[UInt8]] = Array(repeating: Array(repeating: 0, count: width), count: height)
    var score = 0
    var best = 0
    
    var emptyGrids: [(row: Int, col: Int)] {
        var list: [(Int, Int)] = []
        for row in 0..<height {
            for col in 0..<width {
                if valueBoard[row][col] == 0 {
                    list.append((row, col))
                }
            }
        }
        return list
    }
    
    var gameOver: Bool {
        for row in 0..<height {
            for col in 0..<width {
                if valueBoard[row][col] == 0 || (row+1 < height && valueBoard[row][col] == valueBoard[row+1][col]) || (col+1 < width && valueBoard[row][col] == valueBoard[row][col+1]) {
                    return false
                }
            }
        }
        return true
    }
    
    func newGame() -> [Tile] {
        valueBoard = Array(repeating: Array(repeating: 0, count: width), count: height)
        score = 0
        
        var localEmptyGrids = emptyGrids
        var initTiles: [Tile] = []
        for _ in 0..<initTilesAmount {
            let idx = Int.random(in: 0..<localEmptyGrids.count)
            let loc = localEmptyGrids.remove(at: idx)
            valueBoard[loc.row][loc.col] = chessValueInit
            
            initTiles.append(.init(value: valueBoard[loc.row][loc.col], row: loc.row, col: loc.col))
        }
        
        return initTiles
    }
    
    private var chessValueInit: UInt8 {
        UInt8.random(in: 0..<10) < 9 ? 1 : 2  // 90% 为 2，10% 为 4
    }
    
    private func newTile() -> Tile {
        let loc = emptyGrids.randomElement()!
        valueBoard[loc.row][loc.col] = chessValueInit
        
        return Tile(value: valueBoard[loc.row][loc.col], row: loc.row, col: loc.col)
    }
    
    func merge(direction: Direction) -> (merges: Merges, newTile: Tile?, scoreIncrease: Int) {
        var merges = Merges()
        var scoreIncrease = 0
        
        var range: Range<Int>
        switch direction {
        case .left, .right:
            range = 0..<height
        default:
            range = 0..<width
        }
        
        for i in range {
            switch direction {
            case .left, .right:
                eatRow(row: i)
                translateRow(row: i)
            default:
                eatCol(col: i)
                translateCol(col: i)
            }
        }
        
        if merges.actions.isEmpty {
            return (merges, nil, scoreIncrease)
        }
        
        score += scoreIncrease
        best = max(best, score)
        
        return (merges, newTile(), scoreIncrease)
        
        
        
        func eatRow(row: Int) {
            var colArray: [(col: Int, merged: Bool)]
            if direction == .left {
                colArray = (0..<width).map() { ($0, false) }
            } else {
                colArray = (0..<width).reversed().map() { ($0, false) }
            }
            
            for (i, eat) in colArray.enumerated() {
                if eat.merged || valueBoard[row][eat.col] == 0 {
                    continue
                }
                for (j, eaten) in colArray[(i+1)...].enumerated() {
                    if !eaten.merged && valueBoard[row][eaten.col] == 0 {
                        continue
                    } else if valueBoard[row][eaten.col] == valueBoard[row][eat.col] {
                        //can be merged
                        merges.addEat(eaten: Merges.Position(col: eaten.col, row: row), eat: Merges.Position(col: eat.col, row: row), direction: direction)
                        colArray[j+i+1].merged = true
                        //update the valueBoard
                        valueBoard[row][eaten.col] = 0
                        valueBoard[row][eat.col] += 1
                        scoreIncrease += 1 << valueBoard[row][eat.col]
                    }
                    break
                }
            }
        }
        
        func eatCol(col: Int) {
            var rowArray: [(row: Int, merged: Bool)]
            if direction == .up {
                rowArray = (0..<height).map { ($0, false) }
            } else {
                rowArray = (0..<height).reversed().map { ($0, false) }
            }
            
            for (i, eat) in rowArray.enumerated() {
                if eat.merged || valueBoard[eat.row][col] == 0 {
                    continue
                }
                for (j, eaten) in rowArray[(i+1)...].enumerated() {
                    if !eaten.merged && valueBoard[eaten.row][col] == 0 {
                        continue
                    } else if valueBoard[eaten.row][col] == valueBoard[eat.row][col] {
                        //can be merged
                        merges.addEat(eaten: Merges.Position(col: col, row: eaten.row), eat: Merges.Position(col: col, row: eat.row), direction: direction)
                        rowArray[j+i+1].merged = true
                        //update the valueBoard
                        valueBoard[eaten.row][col] = 0
                        valueBoard[eat.row][col] += 1
                        scoreIncrease += 1 << valueBoard[eat.row][col]
                    }
                    break
                }
            }
        }
        
        func translateRow(row: Int) {
            var colArray = Array(0..<width)
            if direction == .right {
                colArray.reverse()
            }
            
            for (i, col) in colArray.enumerated() {
                if valueBoard[row][col] == 0 {
                    continue
                }
                
                var dstCol = col
                for toCol in colArray[..<i].reversed() {
                    if valueBoard[row][toCol] == 0 {
                        dstCol = toCol
                    } else {
                        break
                    }
                }
                
                if dstCol != col {
                    merges.addTranslate(from: Merges.Position(col: col, row: row), to: Merges.Position(col: dstCol, row: row), direction: direction)
                    valueBoard[row].swapAt(col, dstCol)
                }
            }
        }
        
        func translateCol(col: Int) {
            var rowArray = Array(0..<height)
            if direction == .down {
                rowArray.reverse()
            }
            
            for (i, row) in rowArray.enumerated() {
                if valueBoard[row][col] == 0 {
                    continue
                }
                
                var dstRow = row
                for toRow in rowArray[..<i].reversed() {
                    if valueBoard[toRow][col] == 0 {
                        dstRow = toRow
                    } else {
                        break
                    }
                }
                
                if dstRow != row {
                    merges.addTranslate(from: Merges.Position(col: col, row: row), to: Merges.Position(col: col, row: dstRow), direction: direction)
                    valueBoard[dstRow][col] = valueBoard[row][col]
                    valueBoard[row][col] = 0
                }
            }
        }
    }
    
}

