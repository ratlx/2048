//
//  ContentView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/6.
//

import SwiftUI

struct ContentView: View {
    @State private var newGameAnimate = false
    @State private var tiles: [TileViewModel] = [TileViewModel(value: 1, row: 0, col: 3)]
    @Environment(Game.self) var game
    
    var body: some View {
        VStack {
            Button("New Game") {
                newGameAnimate = false
                game.newGame()
                withAnimation(.easeIn(duration: 0.2)) {
                    newGameAnimate = true
                }
            }
            
            
            ZStack {
                BoardView()
                /*TileView(tileViewModel: tiles[0])
                    .opacity(newGameAnimate ? 1 : 0)
                    .scaleEffect(newGameAnimate ? 1 : 0)
                    .offset(x: tiles[0].x, y: tiles[0].y)*/
                
                HStack(spacing: gridMargin) {
                    ForEach(0..<width, id: \.self) { col in
                        VStack(spacing: gridMargin) {
                            ForEach(0..<height, id: \.self) { row in
                                if game.valueBoard[row][col] > 0 {
                                    TileView(tileViewModel: TileViewModel(value: game.valueBoard[row][col], row: 0, col: 0))
                                        .id(game.valueBoard[row][col])
                                } else {
                                    Color.clear
                                        .frame(width: gridSize, height: gridSize)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                withAnimation(.easeIn(duration: 0.2)) {
                    newGameAnimate = true
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    let verticalAmount = value.translation.height

                    if abs(horizontalAmount) > abs(verticalAmount) {
                        if horizontalAmount > 0 {
                            game.merge(direction: .right)
                        } else {
                            game.merge(direction: .left)
                        }
                    } else {
                        if verticalAmount > 0 {
                            game.merge(direction: .down)
                        } else {
                            game.merge(direction: .up)
                        }
                    }
                    
                }
        )
    }
}

#Preview {
    ContentView()
        .environment(Game())
}
