//
//  aiButton.swift
//  2048
//
//  Created by 小火锅 on 2025/4/20.
//

import SwiftUI

struct aiButton: View {
    @Binding var aiEnable: Bool
    
    var body: some View {
        Button {
            aiEnable.toggle()
        } label: {
            Label("Enable AI", systemImage: "brain.head.profile.fill")
                .symbolEffect(.bounce, isActive: aiEnable)
                .foregroundStyle(aiEnable ? Color(red: 60/255, green: 50/255, blue: 45/255) : brightTextColor)
                .fontWeight(.bold)
        }
        .padding(4)
        .background {
            RoundedRectangle(cornerRadius: tileRadius)
                .fill(buttonBackGroundColor)
        }
    }
}

#Preview {
    @Previewable @State var aiEnable = false
    aiButton(aiEnable: $aiEnable)
}
