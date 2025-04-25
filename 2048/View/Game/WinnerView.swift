//
//  WinnerView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import SwiftUI

struct WinnerView: View {
    @Binding var isRestart: Bool
    @Binding var isKeepGoing: Bool
    @Binding var isButtonEnabled: Bool
    @Environment(GameSize.self) var gameSize
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: boardRadius)
                .frame(width: gameSize.boardWidth, height: gameSize.boardHeight)
                .foregroundStyle(tileGoldColor.opacity(0.5))
            
            VStack {
                Text("You win!")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                
                HStack {
                    Button {
                        isKeepGoing.toggle()
                    } label: {
                        Text("Keep going")
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
                    
                    Button {
                        isRestart = true
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
                }
            }
            .offset(y: (gameSize.gridSize - gameSize.gridMargin) / 2)
        }
    }
}

#Preview {
    @Previewable @State var isRestart = false
    @Previewable @State var isKeepGoing = false
    @Previewable @State var isButtonEnabled = false
    WinnerView(isRestart: $isRestart, isKeepGoing: $isKeepGoing, isButtonEnabled: $isButtonEnabled)
        .environment(GameSize())
}
