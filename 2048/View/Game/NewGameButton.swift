//
//  NewGameView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/3.
//

import SwiftUI


struct NewGameButton: View {
    @Binding var isRestart: Bool
    @Environment(GameSize.self) var gameSize
    
    var body: some View {
        Button {
            isRestart.toggle()
        } label: {
            Text("New Game")
                .padding(.horizontal, 4.0)
                .foregroundStyle(brightTextColor)
                .font(.headline)
                .fontWeight(.bold)
                .background {
                    RoundedRectangle(cornerRadius: tileRadius)
                        .fill(Color(red: 150/255, green: 138/255, blue: 128/255))
                }
                .frame(width: gameSize.gridSize * 1.2)
        }
    }
}

#Preview {
    @Previewable @State var isRestart = false
    NewGameButton(isRestart: $isRestart)
        .environment(GameSize())
}
