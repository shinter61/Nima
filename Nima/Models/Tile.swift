//
//  Tile.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import Foundation

struct Tile: Hashable, Codable {
    var kind: String
    var number: Int
    var character: String
    
    func name() -> String {
        if number == 0 {
            return character
        } else {
            return "\(number)\(kind)"
        }
    }
    
    func isEqual(tile: Tile) -> Bool {
        if number == 0 {
            return character == tile.character
        } else {
            return number == tile.number && kind == tile.kind
        }
    }
    
    func next() -> Tile {
        var tileNum = 0
        let windArr = ["east", "south", "west", "north"]
        let dragonArr = ["white", "green", "red"]
        if kind == "sou" {
            tileNum = number
            tileNum += 1
            if (tileNum == 10) { tileNum = 1 }
            return Tile(kind: "sou", number: tileNum, character: "")
        } else if kind == "pin" || kind == "man" {
            tileNum = number == 1 ? 9 : 1
            return Tile(kind: kind, number: tileNum, character: "")
        } else if windArr.contains(character) {
            var idx = windArr.firstIndex(of: character)!
            idx += 1
            if idx == 4 { idx = 0 }
            return Tile(kind: "", number: 0, character: windArr[idx])
        } else {
            var idx = dragonArr.firstIndex(of: character)!
            idx += 1
            if idx == 3 { idx = 0 }
            return Tile(kind: "", number: 0, character: dragonArr[idx])
        }
    }
}

struct WaitCandidate: Hashable, Codable {
    var tile: Tile
    var waitTiles: [Tile]
}
