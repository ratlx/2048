//
//  GoalView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import SwiftUI

struct GoalView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("合并数字，拼出 ")
                .font(.title3)
                .foregroundStyle(textColor)
            Text("2048")
                .font(.title3)
                .foregroundStyle(textColor)
                .bold()
            Text(" 方块！")
                .font(.title3)
                .foregroundStyle(textColor)
        }
    }
}

#Preview {
    GoalView()
}
