//
//  GameView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/30.
//

import SwiftUI
import _048_ai

struct GameView: View {
    @State private var tileViews: [TileViewModel] = []
    @State private var newAnimateTiles: Set<UUID> = []
    @State private var eatAnimateTiles: Set<UUID> = []
    @State private var increaseList = IncreaseList()
    
    private let mergingQueue = DispatchQueue(label: "com.2048.mergingQueue")
    @State private var aiInterrupt = false
    @State private var lastMerge = Date()
    @State private var timeInterval: Double = 0.1
    
    @State private var isRestart = false
    @State private var isGameOver = false
    @State private var isKeepGoing = true
    @State private var isButtonEnabled = false
    @State private var isAIEnable = false
    @Environment(Game.self) var game
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                BestView()
                ScoreView(increaseList: increaseList)
                NewGameButton(isRestart: $isRestart)
                    .environment(game.gameSize)
            }
            ZStack {
                PlaygroundView(tileViews: $tileViews, newAnimateTiles: $newAnimateTiles, eatAnimateTiles: $eatAnimateTiles)
                
                GameOverView(isRestart: $isRestart, isButtonEnabled: $isButtonEnabled)
                    .opacity(isGameOver ? 1 : 0)
                
                WinnerView(isRestart: $isRestart, isKeepGoing: $isKeepGoing, isButtonEnabled: $isButtonEnabled)
                    .opacity(game.winner ? 1 : 0)
                    .opacity(isGameOver || isKeepGoing ? 0 : 1)
            }
            .environment(game.gameSize)
            .onAppear {
                tilesPopUp(type: .initialize)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        guard isKeepGoing && !isAIEnable else { return }
                        mergingQueue.async {
                            manulMerge(from: value)
                        }
                    }
            )
            .onChange(of: isRestart) {
                tilesPopUp(type: .newGame)
            }
            .onChange(of: isAIEnable) {
                mergingQueue.async {
                    aiMerge()
                }
            }
            
            aiButton(aiEnable: $isAIEnable)
                .offset(y: 10)
        }
    }
    
    private func manulMerge(from value: DragGesture.Value) {
        let horizontalAmount = value.translation.width
        let verticalAmount = value.translation.height
        let direction: Direction
        
        if abs(horizontalAmount) > abs(verticalAmount) {
            direction = horizontalAmount > 0 ? .right : .left
        } else {
            direction = verticalAmount > 0 ? .down : .up
        }
        
        doMerge(direction: direction)
    }
    
    private func aiMerge() {
        while isAIEnable && !aiInterrupt {
            if isKeepGoing {
                let bestMove = find_best_move(game.cxxBoard)
                if let direction = Direction(rawValue: bestMove) {
                    doMerge(direction: direction)          // It may not be available under preview
                }
            }
            Thread.sleep(forTimeInterval: 0.05)
        }
    }
    
    enum PopUpType {
        case initialize
        case newGame
    }
    
    private func tilesPopUp(type: PopUpType) {
        isGameOver = false
        newAnimateTiles.removeAll()
        isKeepGoing = true
        aiInterrupt = true
        
        mergingQueue.async {
            let initTiles = type == .newGame ? game.newGame() : game.gameInitialize()
            tileViews = initTiles.map { TileViewModel(tile: $0) }
            withAnimation(.easeIn(duration: 0.2)) {
                for tileView in tileViews {
                    newAnimateTiles.insert(tileView.id)
                }
            }
            if type == .initialize {
                gameOverCheck()
            }
            aiInterrupt = false
            if isAIEnable {
                aiMerge()
            }
        }
    }
    
    private var moveTime: Double {
        min(0.1, timeInterval)
    }
    
    private func doMerge(direction: Direction) {
        let result = game.merge(direction: direction)
        guard let _ = result.newTile else { return }
        
        timeInterval = -lastMerge.timeIntervalSinceNow
        increaseList.add(value: result.scoreIncrease)
        
        animate(merges: result.merges, tile: result.newTile!)
        
        gameWinnerCheck()
        gameOverCheck()
        game.save()
        
        func animate(merges: Merges, tile: Tile) {
            var eatList = Set<UUID>()
            
            tileViews = tileViews.filter { $0.zState == .above }
            for tileView in tileViews {
                if let action = merges.actions[.init(col: tileView.col, row: tileView.row)] {
                    if action.eat == nil && !action.onlyTranslate {
                        tileView.zState = .below
                    } else if action.eat != nil {
                        eatList.insert(tileView.id)
                    }
                }
            }
            
            withAnimation(.easeInOut(duration: moveTime)) {
                for tileView in tileViews {
                    if let action = merges.actions[.init(col: tileView.col, row: tileView.row)] {
                        tileView.move(dx: action.dx ?? 0, dy: action.dy ?? 0)
                    }
                }
            }
            
            print("sleep: \(moveTime)")
            Thread.sleep(forTimeInterval: moveTime)
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
            
            lastMerge = .now
        }
    }
    
    private func gameOverCheck() {
        guard game.gameOver else { return }
        
        isButtonEnabled = false
        withAnimation(.easeIn(duration: 0.8).delay(1.2)) {
            isGameOver = true
            isKeepGoing = false
        }
    
        Thread.sleep(forTimeInterval: 2)
        isButtonEnabled = true
    }
    
    private func gameWinnerCheck() {
        guard game.isWinner else { return }
        
        isButtonEnabled = false
        withAnimation(.easeIn(duration: 0.8).delay(1.2)) {
            isKeepGoing = false
        }
        
        Thread.sleep(forTimeInterval: 2)
        isButtonEnabled = true
    }
}

#Preview {
    GameView()
        .environment(Game(gameSize: GameSize()))
}
