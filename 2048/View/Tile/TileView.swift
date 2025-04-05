//
//  TileView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/7.
//

import SwiftUI

let tileRadius: CGFloat = 3

struct TileView: View {
    @Bindable var tileViewModel: TileViewModel
    @Environment(GameSize.self) var gameSize
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: tileRadius)
                .fill(tileViewModel.backgroundColor
                    .shadow(
                        .inner(color: tileViewModel.innerShadowColor,
                               radius: tileViewModel.innerShadowRadius
                              )
                    )
                )
                .frame(width: gameSize.gridSize, height: gameSize.gridSize)
                .shadow(color: tileViewModel.shadowColor, radius: 30)
            
                
                
            
            Text(tileViewModel.text)
                .font(.system(size: tileViewModel.fontSize, weight: .bold))
                .frame(width: gameSize.gridSize, height: gameSize.gridSize, alignment: .center)
                .foregroundColor(tileViewModel.fontColor)
        }

    }
    
    init(value: UInt8, row: Int = 0, col: Int = 0, gameSize: GameSize) {
        tileViewModel = TileViewModel(tile: Tile(value: value, row: row, col: col, gameSize: gameSize))
    }
    
    init(tileViewModel: TileViewModel) {
        self.tileViewModel = tileViewModel
    }
}

#Preview {
    @Previewable @State var gameSize = GameSize()
    VStack(spacing: 20) {
        TileView(value: 11, gameSize: gameSize)
            
        TileView(value: 10, gameSize: gameSize)
    }
    .environment(gameSize)
}
