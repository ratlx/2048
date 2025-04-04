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
    @Environment(BoardSize.self) var boardSize
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: boardSize.boardWidth, height: boardSize.boardHeight)
                .foregroundStyle(tileGoldColor.opacity(0.5))
            
            VStack {
                Text("You win!")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                
                HStack {
                    Button {
                        isKeepGoing = true
                    } label: {
                        Text("Keep going")
                            .font(.callout)
                            .bold()
                            .foregroundStyle(brightTextColor)
                            .padding(4)
                            .background {
                                RoundedRectangle(cornerRadius: 3)
                                    .foregroundStyle(textColor)
                            }
                    }
                    
                    Button {
                        isRestart = true
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
            }
            .offset(y: (gridSize - gridMargin) / 2)
        }
    }
}

#Preview {
    @Previewable @State var isRestart = false
    @Previewable @State var isKeepGoing = false
    WinnerView(isRestart: $isRestart, isKeepGoing: $isKeepGoing)
        .environment(BoardSize())
}
