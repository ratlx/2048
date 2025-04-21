//
//  GameView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/30.
//

import SwiftUI
import _048_ai

private let mergingQueue = DispatchQueue(label: "com.2048.mergingQueue")
private var aiInterrupt = false
private var isTooFast = false
private var lastMerge = Date()

struct GameView: View {
    @State private var tileViews: [TileViewModel] = []
    @State private var newAnimateTiles: Set<UUID> = []
    @State private var eatAnimateTiles: Set<UUID> = []
    @State private var increaseList = IncreaseList()
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
                    .opacity(isKeepGoing ? 0 : 1)
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
                doMerge(direction: Direction(rawValue: bestMove)!)
            } else {
                Thread.sleep(forTimeInterval: 0.3)
            }
        }
    }
    
    enum PopUpType {
        case initialize
        case newGame
        case update
    }
    
    private func tilesPopUp(type: PopUpType) {
        isGameOver = false
        newAnimateTiles.removeAll()
        isKeepGoing = true
        aiInterrupt = true
        
        mergingQueue.async {
            let initTiles = type == .newGame ? game.newGame() : game.gameInitialize()
            tileViews = initTiles.map { TileViewModel(tile: $0) }
            withAnimation(type == .update ? .none : .easeIn(duration: 0.2)) {
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
    
    private func gameExamine() {
        let now = Date()
        if now.timeIntervalSince(lastMerge) <= 0.3 {
            isTooFast = true
        } else if isTooFast {
            isTooFast = false
        }
        lastMerge = now
    }
    
    private func doMerge(direction: Direction) {
        let result = game.merge(direction: direction)
        guard let _ = result.newTile else { return }
        
        gameExamine()
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
            
            withAnimation(.easeInOut(duration: 0.1)) {
                for tileView in tileViews {
                    if let action = merges.actions[.init(col: tileView.col, row: tileView.row)] {
                        tileView.move(dx: action.dx ?? 0, dy: action.dy ?? 0)
                    }
                }
            }
            
            if !isTooFast {
                Thread.sleep(forTimeInterval: 0.1)
            }
            for tileView in tileViews {
                if eatList.contains(tileView.id) {
                    tileView.increase()
                }
            }
            tileViews.append(.init(tile: tile))
            eatAnimateTiles = eatList
            
            if !eatList.isEmpty && !isTooFast {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
            
            withAnimation(.spring(duration: 0.2, bounce: 0.5)) {
                eatAnimateTiles.removeAll()
            }
            
            withAnimation(.easeIn(duration: 0.2)) {
                let _ = newAnimateTiles.insert(tileViews.last!.id)
            }
        }
    }
    
    private func gameOverCheck() {
        guard game.gameOver else { return }
        
        isButtonEnabled = false
        isKeepGoing = false
        withAnimation(.easeIn(duration: 0.8).delay(1.2)) {
            isGameOver = true
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
