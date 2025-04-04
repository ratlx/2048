//
//  BoardView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/11.
//

import SwiftUI

let gridMargin: CGFloat = 10
let gameContainerColor = Color(red: 187/255, green: 173/255, blue: 160/255)

extension BoardSize {
    var boardWidth: CGFloat {
        CGFloat(width) * (gridMargin + gridSize) + gridMargin
    }
    var boardHeight: CGFloat {
        CGFloat(height) * (gridMargin + gridSize) + gridMargin
    }
}

struct BoardView: View {
    @Environment(BoardSize.self) var boardSize
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: boardSize.boardWidth, height: boardSize.boardHeight)
                .foregroundColor(gameContainerColor)
            HStack(spacing: gridMargin) {
                ForEach(0..<boardSize.width, id: \.self) { _ in
                    VStack(spacing: gridMargin) {
                        ForEach(0..<boardSize.height, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 3)
                                .frame(width: gridSize, height: gridSize)
                                .foregroundColor(Color(red: 238/255, green: 228/255, blue: 218/255, opacity: 0.35))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BoardView()
        .environment(BoardSize())
}
