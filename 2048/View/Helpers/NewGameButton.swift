//
//  NewGameView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/3.
//

import SwiftUI


struct NewGameButton: View {
    @Binding var isRestart: Bool
    
    var body: some View {
        Button {
            isRestart.toggle()
        } label: {
            Text("New Game")
                .padding(.horizontal, 4.0)
                .foregroundStyle(brightTextColor)
                .font(.title3)
                .fontWeight(.bold)
                .background {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(red: 150/255, green: 138/255, blue: 128/255))
                }
                .frame(width: gridSize * 1.2)
        }
    }
}

#Preview {
    @Previewable @State var isRestart = false
    NewGameButton(isRestart: $isRestart)
}
