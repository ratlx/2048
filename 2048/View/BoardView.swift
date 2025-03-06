//
//  BoardView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/11.
//

import SwiftUI

let gridMargin: CGFloat = 10

struct BoardView: View {
    let boardWidth: CGFloat = CGFloat(width) * (gridMargin + gridSize) + gridMargin
    let boardHeight: CGFloat = CGFloat(height) * (gridMargin + gridSize) + gridMargin
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: boardWidth, height: boardHeight)
                .foregroundColor(Color(red: 187/255, green: 173/255, blue: 160/255))
            HStack(spacing: gridMargin) {
                ForEach(0..<width, id: \.self) { _ in
                    VStack(spacing: gridMargin) {
                        ForEach(0..<height, id: \.self) { _ in
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
}
