//
//  BoardSize.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import Foundation

@Observable
class BoardSize {
    var width: Int
    var height: Int
    
    init(width: Int = 4, height: Int = 4) {
        self.width = width
        self.height = height
    }
}
