//
//  TitleView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        Text("2048")
            .font(.largeTitle)
            .bold()
            .foregroundStyle(textColor)
    }
}

#Preview {
    TitleView()
}
