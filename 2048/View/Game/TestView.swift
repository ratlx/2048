//
//  TestView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/29.
//

import SwiftUI

struct TestView: View {
    @Environment(Game.self) var game
    
    var body: some View {
        ZStack {
            BoardView()
            
            HStack(spacing: gridMargin) {
                ForEach(0..<width, id: \.self) { col in
                    VStack(spacing: gridMargin) {
                        ForEach(0..<height, id: \.self) { row in
                            if game.valueBoard[row][col] > 0 {
                                TileView(value: game.valueBoard[row][col])
                            } else {
                                Color.clear
                                    .frame(width: gridSize, height: gridSize)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TestView()
        .environment(Game())
}
