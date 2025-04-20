//
//  GameOverView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import SwiftUI

struct GameOverView: View {
    @Binding var isRestart: Bool
    @Binding var isButtonEnabled: Bool
    @Environment(GameSize.self) var gameSize
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: boardRadius)
                .frame(width: gameSize.boardWidth, height: gameSize.boardHeight)
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
                            RoundedRectangle(cornerRadius: tileRadius)
                                .foregroundStyle(textColor)
                        }
                }
                .disabled(!isButtonEnabled)
                
                /*Button("bigger") {
                    gameSize.height += 1
                    gameSize.width += 1
                }*/
            }
            .offset(y: (gameSize.gridSize - gameSize.gridMargin) / 2)
        }
    }
}

#Preview {
    @Previewable @State var isRestart = false
    @Previewable @State var isButtonEnabled = false
    GameOverView(isRestart: $isRestart, isButtonEnabled: $isButtonEnabled)
        .environment(GameSize())
}
