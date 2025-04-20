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
let tileGoldGlowColor = Color(red: 250/255, green: 227/255, blue: 116/255)

let specialColors: [UInt8: Color] = [3: Color(red: 247/255, green: 142/255, blue: 72/255),
                                     4: Color(red: 252/255, green: 94/255, blue: 46/255),
                                     5: Color(red: 255/255, green: 51/255, blue: 51/255),
                                     6: Color(red: 1, green: 0, blue: 0)]

@Observable
class TileViewModel: Identifiable {
    var tile: Tile
    let id = UUID()
    var zState: Z = .above
    
    enum Z: Double {
        case below = 0
        case above = 1
    }
    
    var text: String {
        String(1 << tile.value)
    }
    
    var fontColor: Color {
        if tile.value <= 2 {
            return textColor
        } else if tile.value < emptyValue {
            return brightTextColor
        }
        return .clear
    }
    
    var fontSize: CGFloat {
        if tile.value < 7 {
            return 0.6 * tile.gameSize.gridSize
        } else if tile.value < 10 {
            return 0.43 * tile.gameSize.gridSize
        } else if tile.value < 12 {
            return 0.34 * tile.gameSize.gridSize
        } else if tile.value < 35 {
            return 0.25 * tile.gameSize.gridSize
        } else if tile.value < emptyValue {
            return 0.2 * tile.gameSize.gridSize
        }
        return 0
    }
    
    var backgroundColor: Color {
        if tile.value < 12 {
            let mixedBackGround = tileColor.mix(with: tileGoldColor, by: goldPercent)
            
            if specialColors.keys.contains(tile.value) {
                return mixedBackGround.mix(with: specialColors[tile.value]!, by: 0.55)
            }
            return mixedBackGround
        } else if tile.value < emptyValue {
            return tileGoldColor.mix(with: Color(red: 3/255, green: 3/255, blue: 3/255), by: 0.95)
        }
        return .clear
    }
    
    var shadowColor: Color {
        tileGoldGlowColor.opacity(glowOpacity / 1.8)
    }
    
    var x: CGFloat {
        tile.x * (tile.gameSize.gridSize + tile.gameSize.gridMargin)
    }
    
    var y: CGFloat {
        tile.y * (tile.gameSize.gridSize + tile.gameSize.gridMargin)
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
    
    private var goldPercent: Double {
        Double(tile.value) / Double(targetValue)
    }
    
    private var glowOpacity: Double {
        guard tile.value > 6 && tile.value <= targetValue else { return 0 }
        return goldPercent
    }
    
    var innerShadowRadius: Double {
        guard tile.value > 6 && tile.value <= targetValue else { return 0 }
        return 3
    }
    
    var innerShadowColor: Color {
        guard tile.value > 6 && tile.value <= targetValue else { return .clear }
        return .white.opacity(glowOpacity / 3)
    }
    
    init(tile: Tile) {
        self.tile = tile
    }
}

