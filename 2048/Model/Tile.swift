//
//  Tile.swift
//  2048
//
//  Created by 小火锅 on 2025/3/18.
//

import Foundation

struct Tile {
    var value: UInt8
    var col: Int
    var row: Int
    var boardSize: BoardSize
    
    var x: CGFloat {
        get {
            let tx = col - boardSize.width / 2
            if boardSize.width & 1 == 0 {
                return CGFloat(tx) + 0.5
            }
            return CGFloat(tx)
        }
        set {
            col = Int(newValue) + boardSize.width / 2
            if boardSize.width & 1 == 0 {
                col -= 1
            }
        }
    }
    
    var y: CGFloat {
        get {
            let ty = row - boardSize.height / 2
            if boardSize.height & 1 == 0 {
                return CGFloat(ty) + 0.5
            }
            return CGFloat(ty)
        }
        set {
            row = Int(newValue) + boardSize.height / 2
            if boardSize.height & 1 == 0 {
                row -= 1
            }
        }
    }
    
    init(value: UInt8 = 0, row: Int, col: Int, boardSize: BoardSize) {
        self.value = value
        self.row = row
        self.col = col
        self.boardSize = boardSize
    }
    
    
}
