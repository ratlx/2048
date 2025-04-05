//
//  GameSize.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import Foundation

@Observable
class GameSize: Codable {
    var width: Int
    var height: Int
    var gridSize: CGFloat
    var gridMargin: CGFloat
    
    init(width: Int = 4, height: Int = 4, gridSize: CGFloat = 57.5, gridMargin: CGFloat = 10) {
        self.width = width
        self.height = height
        self.gridSize = gridSize
        self.gridMargin = gridMargin
    }
}


//use in view
extension GameSize {
    var boardWidth: CGFloat {
        CGFloat(width) * (gridMargin + gridSize) + gridMargin
    }
    var boardHeight: CGFloat {
        CGFloat(height) * (gridMargin + gridSize) + gridMargin
    }
}
