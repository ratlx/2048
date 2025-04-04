//
//  TileViewModel.swift
//  2048
//
//  Created by 小火锅 on 2025/3/7.
//

import Foundation
import SwiftUI

let tileColor = Color(red: 238/255, green: 228/255, blue: 218/255)
let textColor = Color(red: 119/255, green: 110/255, blue: 101/255)
let brightTextColor = Color(red: 249/255, green: 246/255, blue: 242/255)
let tileGoldColor = Color(red: 237/255, green: 194/255, blue: 46/255)

@Observable
class TileViewModel: Identifiable {
    private var tile: Tile
    let id = UUID()
    var zState: Z = .above
    
    enum Z: Double {
        case below = 0
        case above = 1
    }
    
    var text: String {
        String(1 << Int(tile.value))
    }
    
    var fontColor: Color {
        if tile.value > 2 {
            return Color(red: 249/255, green: 246/255, blue: 242/255)
        }
        else if tile.value > 0 {
            return textColor
        }
        return .clear
    }
    
    var fontSize: CGFloat {
        if tile.value < 7 {
            return 35
        }
        else if tile.value < 10 {
            return 25
        }
        else if tile.value < 12 {
            return 20
        }
        else if tile.value < 35 {
            return 15
        }
        return 12
    }
    
    var backgroundColor: Color {
        switch tile.value {
        case 0:
            return tileColor.opacity(0.35)
        case 1:
            return Color(red: 238/255, green: 228/255, blue: 218/255)
        case 2:
            return Color(red: 237/255, green: 224/255, blue: 200/255)
        case 3:
            return Color(red: 242/255, green: 177/255, blue: 121/255)
        case 4:
            return Color(red: 245/255, green: 149/255, blue: 99/255)
        case 5:
            return Color(red: 246/255, green: 124/255, blue: 95/255)
        case 6:
            return Color(red: 246/255, green: 94/255, blue: 59/255)
        case 7:
            return Color(red: 237/255, green: 207/255, blue: 114/255)
        case 8:
            return Color(red: 237/255, green: 204/255, blue: 97/255)
        case 9:
            return Color(red: 237/255, green: 200/255, blue: 80/255)
        case 10:
            return Color(red: 237/255, green: 197/255, blue: 63/255)
        case 11:
            return tileGoldColor
        default:
            return Color(red: 60/255, green: 58/255, blue: 50/255)
        }
    }
    
    var x: CGFloat {
        tile.x * (gridSize + gridMargin)
    }
    
    var y: CGFloat {
        tile.y * (gridSize + gridMargin)
    }
    
    var z: Double {
        zState.rawValue
    }
    
    var col: Int {
        tile.col
    }
    
    var row: Int {
        tile.row
    }
    
    func move(dx: Int = 0, dy: Int = 0) {
        tile.col += dx
        tile.row += dy
    }
    
    func increase() {
        tile.value += 1
    }
    
    init(tile: Tile) {
        self.tile = tile
    }
}

