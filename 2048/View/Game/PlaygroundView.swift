//
//  PlaygroundView.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import SwiftUI

struct PlaygroundView: View {
    @Binding var tileViews: [TileViewModel]
    @Binding var newAnimateTiles: Set<UUID>
    @Binding var eatAnimateTiles: Set<UUID>
    
    var body: some View {
        BoardView()
        
        ForEach(tileViews) { tileView in
            let newAnimate = newAnimateTiles.contains(tileView.id)
            let eatAnimate = !eatAnimateTiles.contains(tileView.id)
            
            TileView(tileViewModel: tileView)
                .scaleEffect(eatAnimate ? 1 : 0)
                .scaleEffect(newAnimate ? 1 : 0)
                .opacity(newAnimate ? 1 : 0)
                .offset(x: tileView.x, y: tileView.y)
                .zIndex(tileView.z)
        }
    }
}

#Preview {
    GameView()
        .environment(Game())
}
