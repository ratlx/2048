//
//  ContentView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/6.
//

import SwiftUI

let backgroundColor = Color(red: 250/255, green: 248/255, blue: 239/255)

struct ContentView: View {
    @Environment(Game.self) var game
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 40) {
                Spacer()
                VStack {
                    TitleView()
                    GoalView()
                }
                GameView()
                Spacer()
                RulesView()
                    .offset(y: -20)
                
            }
            .frame(maxWidth: .infinity)
        }
        .background(backgroundColor)
    }
        
}

#Preview {
    ContentView()
        .environment(Game(gameSize: GameSize()))
}
