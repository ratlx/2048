//
//  Merge.swift
//  2048
//
//  Created by 小火锅 on 2025/3/6.
//

import Foundation

enum Direction: Int {
    case up
    case down
    case left
    case right
}

class Merges {
    struct Position: Hashable, Sendable {
        var col: Int, row: Int
    }
    
    struct Action: Sendable {
        var eat: Position? = nil
        var onlyTranslate = false
        var dx: Int? = nil
        var dy: Int? = nil
    }
    
    var actions: [Position: Action] = [:]
    
    func getAction(x: Int, y: Int) -> Action {
        actions[Position(col: x, row: y)] ?? Action()
    }
    
    func addEat(eaten: Position, eat: Position, direction: Direction) {
        switch direction {
        case .left, .right:
            actions[eaten] = Action(dx: eat.col - eaten.col)
        default:
            actions[eaten] = Action(dy: eat.row - eaten.row)
        }
        actions[eat] = Action(eat: eaten)
    }
    
    func addTranslate(from: Position, to: Position, direction: Direction) {
        if actions.keys.contains(from) {
            switch direction {
            case .left, .right:
                actions[from]!.dx = to.col - from.col
            default:
                actions[from]!.dy = to.row - from.row
            }
            
            if let eaten = actions[from]?.eat {
                switch direction {
                case .left, .right:
                    actions[eaten]!.dx! += to.col - from.col
                default:
                    actions[eaten]!.dy! += to.row - from.row
                }
            } else {
                assertionFailure("Impossible translation after being eaten!")
            }
        } else {
            switch direction {
            case .left, .right:
                actions[from] = Action(onlyTranslate: true, dx: to.col - from.col)
            default:
                actions[from] = Action(onlyTranslate: true, dy: to.row - from.row)
            }
        }
    }
}
