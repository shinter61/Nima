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
}
