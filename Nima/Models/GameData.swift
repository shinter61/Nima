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
    
    @Published var myTiles: [Tile] = []
    @Published var myMinkos: [Tile] = []
    @Published var myAnkans: [Tile] = []
    @Published var myMinkans: [Tile] = []
    @Published var myDiscards: [Tile] = []
    @Published var myDrawWaits: [Tile] = []
    @Published var myRonWaits: [Tile] = []
    @Published var canAnkanTiles: [Tile] = []
    @Published var myRiichiTurn: Int = -1
    
    @Published var yourTiles: [Tile] = []
    @Published var yourMinkos: [Tile] = []
    @Published var yourAnkans: [Tile] = []
    @Published var yourMinkans: [Tile] = []
    @Published var yourDiscards: [Tile] = []
    @Published var yourWaits: [Tile] = []
    @Published var yourRiichiTurn: Int = -1
    
    @Published var doraTiles: [Tile] = []
    @Published var revDoraTiles: [Tile] = []
    
    @Published var myScore: Int = 0
    @Published var yourScore: Int = 0
    
    @Published var opponentID: Int = -1
    @Published var opponentName: String = ""
    @Published var opponentRating: Int = -1
    
    @Published var round: Int = 0
    @Published var roundWind: String = ""
    @Published var honba: Int = 0
    @Published var kyotaku: Int = 0
    @Published var isParent: Bool = false
    @Published var winnerID: Int = -1
    @Published var roundWinnerID: Int = -1
    @Published var roundWinType: String = ""
    
    @Published var timer: Timer!
    @Published var countdown: Int = 100
    
    @Published var isDisconnected: Bool = false
    @Published var isGameEnd: Bool = false
    
    func allReset() -> Void {
        roomID = ""
        stockCount = 0
        myTiles = []
        myMinkos = []
        myAnkans = []
        myMinkans = []
        myDiscards = []
        myDrawWaits = []
        myRonWaits = []
        canAnkanTiles = []
        myRiichiTurn = -1
    
        yourTiles = []
        yourMinkos = []
        yourAnkans = []
        yourMinkans = []
        yourDiscards = []
        yourWaits = []
        yourRiichiTurn = -1
    
        doraTiles = []
        revDoraTiles = []
    
        myScore = 0
        yourScore = 0
    
        opponentID = -1
        opponentName = ""
    
        round = 0
        roundWind = ""
        honba = 0
        kyotaku = 0
        isParent = false
        winnerID = -1
        
        isDisconnected = false
        isGameEnd = false
    }
    
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
    
    func yourTileCount() -> Int {
        return 13 - (yourMinkos.count*3 + yourAnkans.count*3 + yourMinkans.count*3)
    }
    
    func tedashiIndex() -> Int {
        switch yourTileCount() {
        case 13:
            return 6
        case 10:
            return 5
        case 7:
            return 3
        case 4:
            return 2
        case 1:
            return 0
        default:
            return 6
        }
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
    
    func startTimer(initialCount: Int) {
        self.countdown = initialCount
        
        let startTime: Date = Date()
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { _ in
            let current = Date()
            let diff = (Calendar.current.dateComponents([.second], from: startTime, to: current)).second!
            if diff >= initialCount { self.timer?.invalidate() }
            self.countdown = initialCount - diff
        })
    }
    
    func isFuriten() -> Bool {
        var ans = false
        for i in 0..<(myRonWaits.count) {
            for j in 0..<(myDiscards.count) {
                if myRonWaits[i].isEqual(tile: myDiscards[j]) {
                    ans = true
                    break
                }
            }
        }
        return ans
    }
}
