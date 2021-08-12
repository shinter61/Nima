//
//  GameData.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import Foundation

final class GameData: ObservableObject {
    @Published var stock: [Tile] = []
    @Published var myTiles: [Tile] = []
    @Published var yourTiles: [Tile] = []
    @Published var myDiscards: [Tile] = []
    @Published var yourDiscards: [Tile] = []
    
    @Published var playerID: String = UUID().uuidString
    @Published var opponentID: String = ""
    
    func discard(tile: Tile) -> [Tile] {
        let idx: Int = myTiles.firstIndex(where: {$0.isEqual(tile: tile)})!
        let removed: Tile = myTiles.remove(at: idx)
        myDiscards.append(removed)
        return myDiscards
    }
    
    func draw() -> Void {
        let removed: Tile = stock.removeFirst()
        myTiles.append(removed)
    }
    
    func encode(tiles: [Tile]) -> String {
        var jsonStr = ""
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
            let jsonData = try encoder.encode(tiles)
            jsonStr = String(data: jsonData, encoding: .utf8) ?? ""
            print(jsonStr)
        } catch {
            print(error.localizedDescription)
        }
        return jsonStr
    }
    
    func decode(str: String) -> [Tile] {
        let jsonData = str.data(using: .utf8)!
        let decoder = JSONDecoder()
        let tiles = try! decoder.decode(Array<Tile>.self, from: jsonData)
        return tiles
    }
}
