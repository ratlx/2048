//
//  GameView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/30.
//

import SwiftUI

struct GameView: View {
    @State private var tileViews: [TileViewModel] = []
    @State private var newAnimateTiles: Set<UUID> = []
    @State private var eatAnimateTiles: Set<UUID> = []
    @State private var increaseList = IncreaseList()
    @State private var isRestart = false
    @State private var isGameOver = false
    @Environment(Game.self) var game
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                BestView()
                ScoreView(increaseList: increaseList)
                NewGameButton(isRestart: $isRestart)
            }
            ZStack {
                PlaygroundView(tileViews: $tileViews, newAnimateTiles: $newAnimateTiles, eatAnimateTiles: $eatAnimateTiles)
                
                GameOverView(isRestart: $isRestart)
                    .opacity(isGameOver ? 1 : 0)
            }
            .environment(game.boardSize)
            .onAppear {
                tilesPopUp(type: .initialize)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        Task {
                            let direction = getSwipeDirection(from: value)
                            let result = game.merge(direction: direction)
                            guard let _ = result.newTile else { return }
                            
                            increaseList.add(value: result.scoreIncrease)
                            
                            await doMerge(merges: result.merges, newTile: result.newTile!)
                            
                            gameOverCheck()
                            
                            game.save()
                        }
                    }
            )
            .onChange(of: isRestart) {
                tilesPopUp(type: .newGame)
            }
        }
    }
    
    private func getSwipeDirection(from value: DragGesture.Value) -> Direction {
        let horizontalAmount = value.translation.width
        let verticalAmount = value.translation.height

        if abs(horizontalAmount) > abs(verticalAmount) {
            return horizontalAmount > 0 ? .right : .left
        } else {
            return verticalAmount > 0 ? .down : .up
        }
    }
    
    enum popUpType {
        case initialize
        case newGame
    }
    
    private func tilesPopUp(type: popUpType) {
        isGameOver = false
        let initTiles = type == .newGame ? game.newGame() : game.gameInitialize()
        tileViews = initTiles.map { TileViewModel(tile: $0) }
        newAnimateTiles.removeAll()
        
        withAnimation(.easeIn(duration: 0.2)) {
            for tileView in tileViews {
                newAnimateTiles.insert(tileView.id)
            }
        }
        
        if type == .initialize {
            gameOverCheck()
        }
    }
    
    private func doMerge(merges: Merges, newTile tile: Tile) async {
        var eatList = Set<UUID>()

        for tileView in tileViews {
            if let action = merges.actions[.init(col: tileView.col, row: tileView.row)] {
                if action.eat == nil && !action.onlyTranslate {
                    tileView.zState = .below
                } else if action.eat != nil {
                    eatList.insert(tileView.id)
                }
            }
        }

        withAnimation(.easeInOut(duration: 0.1)) {
            for tileView in tileViews {
                if let action = merges.actions[.init(col: tileView.col, row: tileView.row)] {
                    tileView.move(dx: action.dx ?? 0, dy: action.dy ?? 0)
                }
            }
        }

        try? await Task.sleep(nanoseconds: 100_000_000)

        for tileView in tileViews {
            if eatList.contains(tileView.id) {
                tileView.increase()
            }
        }
        tileViews.append(.init(tile: tile))
        eatAnimateTiles = eatList
        
        if !eatList.isEmpty {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }

        withAnimation(.spring(duration: 0.2, bounce: 0.5)) {
            eatAnimateTiles.removeAll()
        }
        
        withAnimation(.easeIn(duration: 0.2)) {
            let _ = newAnimateTiles.insert(tileViews.last!.id)
        }
        
        try? await Task.sleep(nanoseconds: 200_000_000)

        tileViews = tileViews.filter { $0.zState == .above }
    }
    
    private func gameOverCheck() {
        guard game.gameOver else { return }
        
        withAnimation(.easeIn(duration: 0.8).delay(1.2)) {
            isGameOver = true
        }
    }
}

#Preview {
    GameView()
        .environment(Game(boardSize: BoardSize()))
}
