//
//  _048Tests.swift
//  2048Tests
//
//  Created by 小火锅 on 2025/3/28.
//

import Testing
@testable import _048

struct _048Tests {
    @Test func setXY() throws {
        var tile = Tile(row: 2, col: 1, boardSize: BoardSize(width: 5, height: 4))
        
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
    
    @Test func gameOver() throws {
        let game = Game(boardSize: BoardSize())
        game.valueBoard = [[1,2,3,4], [2,3,4,1], [3,4,1,2], [4,1,2,3]]
        game.tilesAmount = 16
        #expect(game.gameOver == true)
        
        game.valueBoard[3][3] = 2
        #expect(game.gameOver == false)
        
        game.valueBoard[3][3] = 0
        #expect(game.gameOver == false)
    }
    
    @Test func doMerge() throws {
        var game = Game(boardSize: BoardSize())
        game.valueBoard = [[1,0,0,1], [1,0,2,1], [0,2,0,1], [1,2,2,1]]
        game.tilesAmount = 11
        
        /*1001
         *1021
         *0201
         *1221*/
        var tile = game.merge(direction: .right).newTile!
        /*xxx2
         *x121
         *xx21
         *x131*/
        
        var expect: [[UInt8]] = [[0,0,0,2], [0,1,2,1], [0,0,2,1], [0,1,3,1]]
        expect[tile.row][tile.col] = tile.value
        
        #expect(game.valueBoard == expect)
        #expect(game.tilesAmount == 10)
        
        game.boardSize = BoardSize(width: 4, height: 5)
        game.valueBoard = [[1,0,0,2], [1,1,3,1], [1,0,0,2], [1,0,0,0], [1,2,3,1]]
        game.tilesAmount = 13
        
        /*1002
         *1131
         *1002
         *1000
         *1231*/
        tile = game.merge(direction: .down).newTile!
        /*xxxx
         *xxx2
         *1xx1
         *21x2
         *2241*/
        
        expect = [[0,0,0,0],[0,0,0,2],[1,0,0,1],[2,1,0,2],[2,2,4,1]]
        expect[tile.row][tile.col] = tile.value
        
        #expect(game.valueBoard == expect)
        #expect(game.tilesAmount == 11)
    }
}
