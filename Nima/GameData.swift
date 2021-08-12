//
//  GameData.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import Foundation

final class GameData: ObservableObject {
    @Published var stockCount: Int = 0
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
    
    // 牌に通し番号をつけてそれでソートするか..?コードは綺麗になるが謎の通し番号がデータに入ることになる
    func organizeTiles() -> Void {
        var newTiles: [Tile] = []
        var pinzuTiles: [Tile] = []
        var souzuTiles: [Tile] = []
        var manzuTiles: [Tile] = []
        var eastTiles: [Tile] = []
        var southTiles: [Tile] = []
        var westTiles: [Tile] = []
        var northTiles: [Tile] = []
        var whiteTiles: [Tile] = []
        var greenTiles: [Tile] = []
        var redTiles: [Tile] = []
        
        for tile in myTiles {
            if tile.kind == "pin" { pinzuTiles.append(tile) }
            else if tile.kind == "sou" { souzuTiles.append(tile) }
            else if tile.kind == "man" { manzuTiles.append(tile) }
            else if tile.character == "east" { eastTiles.append(tile) }
            else if tile.character == "south" { southTiles.append(tile) }
            else if tile.character == "west" { westTiles.append(tile) }
            else if tile.character == "north" { northTiles.append(tile) }
            else if tile.character == "white" { whiteTiles.append(tile) }
            else if tile.character == "green" { greenTiles.append(tile) }
            else if tile.character == "red" { redTiles.append(tile) }
        }
        
        pinzuTiles.sort(by: { $0.number < $1.number })
        souzuTiles.sort(by: { $0.number < $1.number })
        manzuTiles.sort(by: { $0.number < $1.number })
        newTiles = pinzuTiles + souzuTiles + manzuTiles + eastTiles +
            southTiles + westTiles + northTiles + whiteTiles + greenTiles + redTiles
        
        myTiles = newTiles
    }
}
