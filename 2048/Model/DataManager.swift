//
//  DataManager.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import Foundation

let resourcesURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Resources")
let gameDataFileName = "s4.json"

struct DataManager {
    

    static func load<T: Decodable>(filename: String) -> T {
        let fileURL = resourcesURL.appendingPathComponent(filename)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            fatalError("Couldn't find \(filename) at \(fileURL.path)")
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }

    static func save<T: Codable>(_ game: T, _ filename: String) {
        let fileURL = resourcesURL.appendingPathComponent(filename)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted       //自动缩进和换行
        
        do {
            let data = try encoder.encode(game)
            try data.write(to: fileURL)
        } catch {
            fatalError("Couldn't write \(T.self) to \(filename):\n\(error)")
        }
    }
    
    static func initializeGame(filename: String) -> Game {
        let fileURL = resourcesURL.appendingPathComponent(filename)
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: fileURL.path) {

            if !fileManager.fileExists(atPath: resourcesURL.path) {
                do {
                    try fileManager.createDirectory(at: resourcesURL, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    fatalError("Couldn't create Resources directory: \(error)")
                }
            }

            let defaultGame = Game(gameSize: GameSize())

            save(defaultGame, filename)
            
            return defaultGame
        } else {
            return load(filename: filename)
        }
    }
}
