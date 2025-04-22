//
//  Tile.swift
//  2048
//
//  Created by 小火锅 on 2025/3/18.
//

import Foundation

@Observable
class Tile: Hashable {
    var col: Int
    var row: Int
    var gameSize: GameSize
    var value: UInt8
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(col)
        hasher.combine(row)
        hasher.combine(value)
    }
    
    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        return lhs.value == rhs.value && lhs.col == rhs.col && lhs.row == rhs.row
    }
    
    var x: CGFloat {
        get {
            let tx = col - gameSize.width / 2
            if gameSize.width & 1 == 0 {
                return CGFloat(tx) + 0.5
            }
            return CGFloat(tx)
        }
        set {
            col = Int(newValue) + gameSize.width / 2
            if gameSize.width & 1 == 0 {
                col -= 1
            }
        }
    }
    
    var y: CGFloat {
        get {
            let ty = row - gameSize.height / 2
            if gameSize.height & 1 == 0 {
                return CGFloat(ty) + 0.5
            }
            return CGFloat(ty)
        }
        set {
            row = Int(newValue) + gameSize.height / 2
            if gameSize.height & 1 == 0 {
                row -= 1
            }
        }
    }
    
    init(value: UInt8 = 0, row: Int, col: Int, gameSize: GameSize) {
        self.value = value
        self.row = row
        self.col = col
        self.gameSize = gameSize
    }
}
