//
//  RulesView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import SwiftUI

struct RulesView: View {
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 0) {
                Text("游戏规则：")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(textColor)
                
                Text("滑动屏幕移动方块。当两个")
                    .font(.subheadline)
                    .foregroundStyle(textColor)
            }
            
            HStack(spacing: 0) {
                Text("相同数字的方块碰撞时，它们会")
                    .font(.subheadline)
                    .foregroundStyle(textColor)
                Text("合并成更大的数字！")
                    .font(.subheadline)
                    .foregroundStyle(textColor)
                    .bold()
            }
        }
    }
}

#Preview {
    RulesView()
}
