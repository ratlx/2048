//
//  TileView.swift
//  2048
//
//  Created by 小火锅 on 2025/3/7.
//

import SwiftUI

let gridSize: CGFloat = 57.5

struct TileView: View {
    @Bindable var tileViewModel: TileViewModel
    @Environment(BoardSize.self) var boardSize
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: gridSize, height: gridSize)
                .foregroundColor(tileViewModel.backgroundColor)
            
            Text(tileViewModel.text)
                .font(.system(size: tileViewModel.fontSize, weight: .bold))
                .frame(width: gridSize, height: gridSize, alignment: .center)
                .foregroundColor(tileViewModel.fontColor)
        }

    }
    
    init(value: UInt8, row: Int = 0, col: Int = 0, boardSize: BoardSize) {
        tileViewModel = TileViewModel(tile: Tile(value: value, row: row, col: col, boardSize: boardSize))
    }
    
    init(tileViewModel: TileViewModel) {
        self.tileViewModel = tileViewModel
    }
}

#Preview {
    @Previewable @State var boardSize = BoardSize()
    TileView(value: 11, boardSize: boardSize)
        .environment(boardSize)
}
