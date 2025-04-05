//
//  BoardView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/11.
//

import SwiftUI

let gameContainerColor = Color(red: 187/255, green: 173/255, blue: 160/255)
let boardRadius: CGFloat = 6

struct BoardView: View {
    @Environment(GameSize.self) var gameSize
    
    var body: some View {
        HStack(spacing: gameSize.gridMargin) {
            ForEach(0..<gameSize.width, id: \.self) { _ in
                VStack(spacing: gameSize.gridMargin) {
                    ForEach(0..<gameSize.height, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: tileRadius)
                            .frame(width: gameSize.gridSize, height: gameSize.gridSize)
                            .foregroundColor(tileColor.opacity(0.35))
                    }
                }
            }
        }
        .padding(gameSize.gridMargin)
        .background {
            RoundedRectangle(cornerRadius: boardRadius)
                .foregroundColor(gameContainerColor)
        }
    }
}

#Preview {
    BoardView()
        .environment(GameSize())
}
