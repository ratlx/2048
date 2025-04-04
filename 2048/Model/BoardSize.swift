//
//  BoardSize.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import Foundation

@Observable
class BoardSize: Codable {
    var width: Int
    var height: Int
    
    init(width: Int = 4, height: Int = 4) {
        self.width = width
        self.height = height
    }
}


//use in view
extension BoardSize {
    var boardWidth: CGFloat {
        CGFloat(width) * (gridMargin + gridSize) + gridMargin
    }
    var boardHeight: CGFloat {
        CGFloat(height) * (gridMargin + gridSize) + gridMargin
    }
}
