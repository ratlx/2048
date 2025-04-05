//
//  ScoreView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/3.
//

import SwiftUI

struct ScoreView: View {
    @Bindable var increaseList: IncreaseList
    @Environment(Game.self) var game
    
    var body: some View {
        InfoView(type: .current)
        .overlay(alignment: .center) {
            ForEach(increaseList.list) { increase in
                
                Text("+\(increase.value)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(textColor)
                    .offset(y: increase.animate ? 10 : -game.gameSize.gridSize)
                    .opacity(increase.animate ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.6)) {
                            increase.animate = false
                        }
                    }
            }
        }
    }

}

#Preview {
    @Previewable @State var l = IncreaseList()
    ScoreView(increaseList: l)
        .environment(Game(gameSize: GameSize()))
}
