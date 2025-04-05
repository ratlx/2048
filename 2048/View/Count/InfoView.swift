//
//  InfoView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/3.
//

import SwiftUI

enum InfoType {
    case current
    case best
}

struct InfoView: View {
    @Environment(Game.self) var game: Game
    let type: InfoType
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text(type == .best ? "BEST" : "SCORE")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(tileColor)
            Text(String(type == .best ? game.best : game.score))
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.top, 6)
        .background {
            RoundedRectangle(cornerRadius: tileRadius)
                .foregroundColor(gameContainerColor)
                .frame(minWidth: game.gameSize.gridSize * 1.5)
        }
        .frame(width: 1.5 * game.gameSize.gridSize)
    }
}

#Preview {
    InfoView(type: .best)
        .environment(Game(gameSize: GameSize()))
}
