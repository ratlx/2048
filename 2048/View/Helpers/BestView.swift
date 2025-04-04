//
//  BestView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/3.
//

import SwiftUI

struct BestView: View {
    var body: some View {
        InfoView(type: .best)
    }
}

#Preview {
    BestView()
        .environment(Game())
}
