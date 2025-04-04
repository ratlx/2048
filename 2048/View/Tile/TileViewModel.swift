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

//let specialColors: [UInt8: Color] = [3: Color(red: )]

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
            return brightTextColor
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
        if tile.value == 0 {
            return tileColor.opacity(0.35)
        } else if tile.value < 12 {
            let mixedBackGround = tileColor.mix(with: tileGoldColor, by: goldPercent)
            
            /*if tile.value >= 3 && tile.value <= 6 {
                switch tile.value {
                case 3:
                    mixedBackGround = mixedBackGround.mix(, by: <#T##Double#>)
                }
            }*/
        }
        return .clear
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
    
    var goldPercent: Double {
        Double(tile.value-1) / 10
    }
    
    init(tile: Tile) {
        self.tile = tile
    }
}

