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
        var tile = Tile(row: 2, col: 1, gameSize: GameSize(width: 5, height: 4))
        
        /*eeeee
         *eeeee
         *exeee
         *eeeee*/
        tile.x += 2
        tile.y -= 1
        /*eeeee
         *eeexe
         *eeeee
         *eeeee*/
        #expect(tile.col == 3 && tile.row == 1)
    }
    
    @Test func gameOver() async throws {
        let game = Game(gameSize: GameSize())
        game.valueBoard = [[1,2,3,4], [2,3,4,1], [3,4,1,2], [4,1,2,3]]
        game.tilesAmount = 16
        #expect(game.gameOver == true)
        
        game.valueBoard[3][3] = 2
        #expect(game.gameOver == false)
        
        game.valueBoard[3][3] = emptyValue
        #expect(game.gameOver == false)
    }
    
    @Test func doMerge() async throws {
        var game = Game(gameSize: GameSize())
        game.valueBoard = [[1,emptyValue,emptyValue,1], [1,emptyValue,2,1], [emptyValue,2,emptyValue,1], [1,2,2,1]]
        game.tilesAmount = 11
        
        /*1ee1
         *1e21
         *e2e1
         *1221*/
        var tile = game.merge(direction: .right).newTile!
        /*eee2
         *e121
         *ee21
         *e131*/
        
        var expect: [[UInt8]] = [[emptyValue,emptyValue,emptyValue,2], [emptyValue,1,2,1], [emptyValue,emptyValue,2,1], [emptyValue,1,3,1]]
        expect[tile.row][tile.col] = tile.value
        
        #expect(game.valueBoard == expect)
        #expect(game.tilesAmount == 10)
        
        game.gameSize = GameSize(width: 4, height: 5)
        game.valueBoard = [[1,emptyValue,emptyValue,2], [1,1,3,1], [1,emptyValue,emptyValue,2], [1,emptyValue,emptyValue,emptyValue], [1,2,3,1]]
        game.tilesAmount = 13
        
        /*1ee2
         *1131
         *1ee2
         *1eee
         *1231*/
        tile = game.merge(direction: .down).newTile!
        /*xxxx
         *xxx2
         *1xx1
         *21x2
         *2241*/
        
        expect = [[emptyValue,emptyValue,emptyValue,emptyValue],[emptyValue,emptyValue,emptyValue,2],[1,emptyValue,emptyValue,1],[2,1,emptyValue,2],[2,2,4,1]]
        expect[tile.row][tile.col] = tile.value
        
        #expect(game.valueBoard == expect)
        #expect(game.tilesAmount == 11)
    }
    
    @Test func winner() async throws {
        var game = Game(gameSize: GameSize())
        game.score = 20000
        
        game.valueBoard[1][1] = targetValue
        
        #expect(game.isWinner == true)
        
        game.valueBoard[1][1] = targetValue + 1
        
        #expect(game.isWinner == false)
    }
}
