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
                .environment(game.boardSize)
            
            HStack(spacing: gridMargin) {
                ForEach(0..<game.boardSize.width, id: \.self) { col in
                    VStack(spacing: gridMargin) {
                        ForEach(0..<game.boardSize.height, id: \.self) { row in
                            if game.valueBoard[row][col] > 0 {
                                TileView(value: game.valueBoard[row][col], boardSize: game.boardSize)
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
        .environment(Game(boardSize: BoardSize()))
}
