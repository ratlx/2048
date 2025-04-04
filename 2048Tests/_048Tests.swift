//
//  _048Tests.swift
//  2048Tests
//
//  Created by 小火锅 on 2025/3/28.
//

import Testing
@testable import _048

struct _048Tests {
    @Test func setXY() async throws {
        width = 5; height = 4
        var tile = Tile(row: 2, col: 1)
        
        /*00000
         *00000
         *0x000
         *00000*/
        tile.x += 2
        tile.y -= 1
        /*00000
         *000x0
         *00000
         *00000*/
        #expect(tile.col == 3 && tile.row == 1)
    }
    
    @Test func gameOver() async throws {
        width = 4; height = 4
        
        var game = Game()
        game.valueBoard = [[1,2,3,4], [2,3,4,1], [3,4,1,2], [4,1,2,3]]
        #expect(game.gameOver == true)
        
        game.valueBoard[3][3] = 2
        #expect(game.gameOver == false)
        
        game.valueBoard[3][3] = 0
        #expect(game.gameOver == false)
    }
    
}
