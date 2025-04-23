//
//  _048App.swift
//  2048
//
//  Created by 小火锅 on 2025/3/6.
//

import SwiftUI

@main
struct _048: App {
    @State private var game: Game
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(game)
        }
    }
    
    init() {
        game = DataManager.initializeGame(filename: gameDataFileName)
    }
}
