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
    
    func reload() -> Void {
        var originalTiles: [Tile] = []
        let characters = ["east", "south", "west", "north", "white", "green", "red"]
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let kinds = ["pin", "sou", "man"]
        
        for i in 0..<characters.count {
            for _ in 0..<4 {
                originalTiles.append(Tile(kind: "", number: 0, character: characters[i]))
            }
        }
        
        for i in 0..<numbers.count {
            for j in 0..<kinds.count {
                if (numbers[i] >= 2 && numbers[i] <= 8 && kinds[j] != "pin") {
                    continue
                }
                for _ in 0..<4 {
                    originalTiles.append(Tile(kind: kinds[j], number: numbers[i], character: ""))
                }
            }
        }
        
        originalTiles.shuffle()
        
        stock = originalTiles // ランダムな山を生成
        
        // 自分と相手の配牌を生成
        for _ in 0..<13 {
            let removed: Tile = stock.removeFirst()
            myTiles.append(removed)
        }
        for _ in 0..<13 {
            let removed: Tile = stock.removeFirst()
            yourTiles.append(removed)
        }
    }
    
    func discard(tile: Tile) -> Void {
        let idx: Int = myTiles.firstIndex(where: {$0.isEqual(tile: tile)})!
        let removed: Tile = myTiles.remove(at: idx)
        myDiscards.append(removed)
    }
    
    func draw() -> Void {
        let removed: Tile = stock.removeFirst()
        myTiles.append(removed)
    }
}
