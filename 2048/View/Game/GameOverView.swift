//
//  GameOverView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import SwiftUI

struct GameOverView: View {
    @Binding var isRestart: Bool
    @Environment(BoardSize.self) var boardSize
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: boardSize.boardWidth, height: boardSize.boardHeight)
                .foregroundStyle(tileColor.opacity(0.5))
            
            VStack {
                Text("Game over!")
                    .font(.title)
                    .bold()
                    .foregroundStyle(textColor)
                
                Button {
                    isRestart.toggle()
                } label: {
                    Text("Try again")
                        .font(.callout)
                        .bold()
                        .foregroundStyle(brightTextColor)
                        .padding(4)
                        .background {
                            RoundedRectangle(cornerRadius: 3)
                                .foregroundStyle(textColor)
                        }
                }
            }
            .offset(y: (gridSize - gridMargin) / 2)
        }
    }
}

#Preview {
    @Previewable @State var isRestart = false
    GameOverView(isRestart: $isRestart)
        .environment(BoardSize())
}
