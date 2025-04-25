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
    @State private var mergingCount = 0
    
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
                mergingQueue.async {
                    tilesPopUp(type: .initialize)
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        mergingQueue.async {
                            manulMerge(from: value)
                        }
                    }
            )
            .onChange(of: isRestart) {
                mergingQueue.async {
                    tilesPopUp(type: .newGame)
                }
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
        guard isKeepGoing && !isAIEnable else { return }
        
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
        guard isAIEnable else { return }
        
        if isKeepGoing {
            let bestMove = find_best_move(game.cxxBoard)
            if let direction = Direction(rawValue: bestMove) {
                doMerge(direction: direction)
            }
        }
        
        mergingQueue.asyncAfter(deadline: .now() + 0.05) {
            aiMerge()
        }
    }
    
    enum PopUpType {
        case initialize
        case newGame
    }
    
    private func tilesPopUp(type: PopUpType) {
        let UIReady = DispatchSemaphore(value: 0)
        isKeepGoing = true
        isGameOver = false

        let initTiles = type == .newGame ? game.newGame() : game.gameInitialize()
        DispatchQueue.main.async {
            animate()
        }
        UIReady.wait()
        
        if type == .initialize {
            gameOverCheck()
        }
        
        func animate() {
            if mergingCount != 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animate()
                }
                return
            }
            newAnimateTiles.removeAll()
            tileViews = initTiles.map { TileViewModel(tile: $0) }
            withAnimation(.easeIn(duration: 0.2)) {
                for tileView in tileViews {
                    newAnimateTiles.insert(tileView.id)
                }
            }
            UIReady.signal()
        }
    }
    
    private func doMerge(direction: Direction) {
        let result = game.merge(direction: direction)
        guard let _ = result.newTile else { return }
        
        DispatchQueue.main.async {
            increaseList.add(value: result.scoreIncrease)
            animate(merges: result.merges, tile: result.newTile!)
        }
        
        gameWinnerCheck()
        gameOverCheck()
        game.save()
        
        func animate(merges: Merges, tile: Tile) {
            mergingCount += 1
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
            let newTile = TileViewModel(tile: tile)
            tileViews.append(newTile)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for tileView in tileViews {
                    if eatList.contains(tileView.id) {
                        tileView.increase()
                    }
                }
                eatAnimateTiles = eatList
                
                if !eatList.isEmpty && mergingCount == 1 {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                
                withAnimation(.spring(duration: 0.2, bounce: 0.5)) {
                    eatAnimateTiles.removeAll()
                }
                
                withAnimation(.easeIn(duration: 0.2)) {
                    let _ = newAnimateTiles.insert(newTile.id)
                }
                mergingCount -= 1
            }
        }
    }
    
    private func gameOverCheck() {
        guard game.gameOver else { return }
        
        isButtonEnabled = false
        DispatchQueue.main.async {
            withAnimation(.easeIn(duration: 0.8).delay(1.2)) {
                isGameOver = true
                isKeepGoing = false
            }
        }
    
        Thread.sleep(forTimeInterval: 2)
        isButtonEnabled = true
    }
    
    private func gameWinnerCheck() {
        guard game.isWinner else { return }
        
        isButtonEnabled = false
        DispatchQueue.main.async {
            withAnimation(.easeIn(duration: 0.8).delay(1.2)) {
                isKeepGoing = false
            }
        }
        
        Thread.sleep(forTimeInterval: 2)
        isButtonEnabled = true
    }
    
    init() {
        init_tables()
    }
}

#Preview {
    GameView()
        .environment(Game(gameSize: GameSize()))
}
