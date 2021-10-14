//
//  GameData.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import Foundation
import SwiftUI

final class GameData: ObservableObject {
    @Published var roomID: String = ""
    @Published var stockCount: Int = 0
    @Published var myTiles: [Tile] = [
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
    ]
    @Published var myMinkos: [Tile] = [
                Tile(kind: "", number: 0, character: "red"),
    ]
    @Published var myAnkans: [Tile] = []
    @Published var myMinkans: [Tile] = []
    
    @Published var myDiscards: [Tile] = []
    @Published var myWaits: [Tile] = [
                Tile(kind: "pin", number: 1, character: ""),
                Tile(kind: "pin", number: 2, character: ""),
                Tile(kind: "pin", number: 4, character: ""),
                Tile(kind: "pin", number: 5, character: ""),
                Tile(kind: "pin", number: 7, character: ""),
    ]
    @Published var yourDiscards: [Tile] = []
    
    @Published var myRiichiTurn: Int = -1
    @Published var yourRiichiTurn: Int = -1
    
    @Published var doraTiles: [Tile] = []
    @Published var revDoraTiles: [Tile] = []
    
    @Published var myScore: Int = 0
    @Published var yourScore: Int = 0
    
//    @Published var playerID: String = UUID().uuidString
    @Published var playerID: String = "shinter"
    @Published var opponentID: String = "droooop"
    
    @Published var round: Int = 0
    @Published var roundWind: String = ""
    @Published var isParent: Bool = false
    @Published var winnerID: String = ""
    
    @Published var timer: Timer!
    @Published var countdown: Int = 3
    
    func discard(tile: Tile) -> [Tile] {
        let idx: Int = myTiles.firstIndex(where: {$0.isEqual(tile: tile)})!
        let removed: Tile = myTiles.remove(at: idx)
        myDiscards.append(removed)
        return myDiscards
    }
    
    func collectToitz() -> [String] {
        var toitzNames: [String] = []
        for i in 0..<(myTiles.count-1) {
            if (myTiles[i].isEqual(tile: myTiles[i+1])) { toitzNames.append(myTiles[i].name()) }
        }
        let uniqToitzNames = Array(Set(toitzNames))
        
        return uniqToitzNames
    }
    
    func collectAnko() -> [String] {
        if myTiles.count <= 1 { return [] }
        
        var ankoNames: [String] = []
        for i in 0..<(myTiles.count-2) {
            if myTiles[i].isEqual(tile: myTiles[i+1]) && myTiles[i+1].isEqual(tile: myTiles[i+2]) { ankoNames.append(myTiles[i].name()) }
        }
        let uniqAnkoNames = Array(Set(ankoNames))
        
        return uniqAnkoNames
    }
    
    func isMyTurn() -> Bool {
        return myTiles.count + myMinkos.count*3 + myMinkans.count*3 + myAnkans.count*3 == 14
    }
    
    func encode(tiles: [Tile]) -> String {
        var jsonStr = ""
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
            let jsonData = try encoder.encode(tiles)
            jsonStr = String(data: jsonData, encoding: .utf8) ?? ""
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
    
    func decodeWaitsCandidate(str: String) -> [WaitCandidate] {
        let jsonData = str.data(using: .utf8)!
        let decoder = JSONDecoder()
        let tiles = try! decoder.decode(Array<WaitCandidate>.self, from: jsonData)
        return tiles
    }
    
    func isMenzen() -> Bool {
        return myMinkos.isEmpty && myMinkans.isEmpty
    }
    
    func start() {
        let startTime: Date = Date()
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { _ in
            let current = Date()
            let diff = (Calendar.current.dateComponents([.second], from: startTime, to: current)).second!
            if diff >= 3 { self.timer?.invalidate() }
            self.countdown = 3 - diff
        })
    }
}
