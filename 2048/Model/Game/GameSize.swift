//
//  GameSize.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import Foundation

//It is not recommended to modify the width and height.
//Because the 2048-AI can be only used in 4*4
//Once you modify the width and height, you should also modify the 
@Observable
class GameSize: Codable {
    var width: Int = 4
    var height: Int = 4
    var gridSize: CGFloat
    var gridMargin: CGFloat
    
    init(gridSize: CGFloat = 57.5, gridMargin: CGFloat = 10, width: Int = 4, height: Int = 4) {
        self.gridSize = gridSize
        self.gridMargin = gridMargin
        self.width = width
        self.height = height
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
