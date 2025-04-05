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
                .environment(game.gameSize)
            
            HStack(spacing: game.gameSize.gridMargin) {
                ForEach(0..<game.gameSize.width, id: \.self) { col in
                    VStack(spacing: game.gameSize.gridMargin) {
                        ForEach(0..<game.gameSize.height, id: \.self) { row in
                            if game.valueBoard[row][col] < emptyValue {
                                TileView(value: game.valueBoard[row][col], gameSize: game.gameSize)
                            } else {
                                Color.clear
                                    .frame(width: game.gameSize.gridSize, height: game.gameSize.gridSize)
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
        .environment(Game(gameSize: GameSize()))
}
