//
//  Tile.swift
//  2048
//
//  Created by 小火锅 on 2025/3/18.
//

import Foundation

struct Tile: Hashable {
    var value: UInt8
    var col: Int
    var row: Int
    
    var x: CGFloat {
        get {
            let tx = col - width / 2
            if width & 1 == 0 {
                return CGFloat(tx) + 0.5
            }
            return CGFloat(tx)
        }
        set {
            col = Int(newValue) + width / 2
            if width & 1 == 0 {
                col -= 1
            }
        }
    }
    
    var y: CGFloat {
        get {
            let ty = row - height / 2
            if height & 1 == 0 {
                return CGFloat(ty) + 0.5
            }
            return CGFloat(ty)
        }
        set {
            col = Int(newValue) + width / 2
            if width & 1 == 0 {
                col -= 1
            }
        }
    }
    
    init(value: UInt8 = 0, row: Int, col: Int) {
        self.value = value
        self.row = row
        self.col = col
    }
    
}
