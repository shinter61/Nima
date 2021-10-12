//
//  GameView.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI
import SocketIO

struct GameView: View {
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var gameService: GameService
    @State private var isMyTurn: Bool = false
    @State private var isWin: Bool = false
    @State private var canRon: Bool = false
    @State private var canPon: Bool = false
    @State private var canDaiminkan: Bool = false
    @State private var canKakan: Bool = false
    @State private var nextKakan: Bool = false
    @State private var nextAnkan: Bool = false
    @State private var canAnkan: Bool = false
    @State private var canRiichi: Bool = false
    @State private var nextRiichi: Bool = false
    @State private var isRiichi: Bool = false
    @State private var showingScore: Bool = false
    @State private var showingEndGame: Bool = false
    @State private var score: Int = 0
    @State private var hands: [String] = []
    @State private var scoreName: String = ""
    @State private var waitsCandidate: [WaitCandidate] = []
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
    }
    
    func addHandler(socket: SocketIOClient!) -> Void {
//        socket.on(clientEvent: .connect) { (data, ack) in
//            socket.emit("StartMatching", gameData.playerID)
//        }
//        socket.on("InformPlayersNames") { (data, ack) in
//            if let dict = data[0] as? [String: String] {
//                if gameData.playerID == dict["player1"] {
//                    gameData.opponentID = dict["player2"]!
//                }
//            }
//            if let dict = data[0] as? [String: String] {
//                if gameData.playerID == dict["player2"] {
//                    gameData.opponentID = dict["player1"]!
//                }
//            }
//        }
        socket.on("InformDiscards") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.opponentID == dict["id"] {
                    gameData.yourDiscards = gameData.decode(str: dict["discards"]!)
                    gameData.yourRiichiTurn = Int(dict["riichiTurn"]!)!
                    if gameData.collectToitz().contains(gameData.yourDiscards.last!.name()) {
                        canPon = true
                    }
                    if gameData.collectAnko().contains(gameData.yourDiscards.last!.name()) {
                        canDaiminkan = true
                    }
                    if gameData.myWaits.map({ $0.name() }).contains(gameData.yourDiscards.last!.name()) {
                        canRon = true
                    }
                    if !(canPon && !isRiichi) && !canRon {
                        socket.emit("Draw", gameData.playerID, false)
                    }
                }
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myDiscards = gameData.decode(str: dict["discards"]!)
                    gameData.myWaits = gameData.decode(str: dict["waits"]!)
                    gameData.myRiichiTurn = Int(dict["riichiTurn"]!)!
                }
            }
        }
        socket.on("DistributeInitTiles") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myScore = Int(dict["score"]!)!
                    gameData.myMinkos = []
                    gameData.myAnkans = []
                    gameData.myMinkans = []
                    gameData.myDiscards = []
                    gameData.yourDiscards = []
                    gameData.stockCount = 0
                    gameData.myRiichiTurn = -1
                    gameData.round = Int(dict["round"]!)!
                    gameData.roundWind = dict["roundWind"]!
                    gameData.isParent = (dict["isParent"] == "true")
                    gameData.doraTiles = gameData.decode(str: dict["doraTiles"]!)
                    
                    if (gameData.isMyTurn()) { isMyTurn = true }
                } else {
                    gameData.yourScore = Int(dict["score"]!)!
                }
            }
        }
        socket.on("Draw") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                gameData.stockCount = Int(dict["stockCount"]!)!
                gameData.doraTiles = gameData.decode(str: dict["doraTiles"]!)
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    if (gameData.isMyTurn()) { isMyTurn = true }
                    if (dict["isWin"] == "true") { isWin = true }
                    waitsCandidate = gameData.decodeWaitsCandidate(str: dict["waitsCandidate"]!)
                    if waitExists() { canRiichi = true }
                    if canKakanExists() { canKakan = true }
                    if canAnkanExists() { canAnkan = true }
                }
            }
        }
        socket.on("Pon") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myMinkos = gameData.decode(str: dict["minkos"]!)
                    gameData.yourDiscards = gameData.decode(str: dict["discards"]!)
                    if (gameData.isMyTurn()) { isMyTurn = true }
                } else {
                    gameData.myDiscards = gameData.decode(str: dict["discards"]!)
                }
            }
        }
        socket.on("Daiminkan") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myMinkans = gameData.decode(str: dict["minkans"]!)
                    gameData.yourDiscards = gameData.decode(str: dict["discards"]!)
                    socket.emit("Draw", gameData.playerID, true) // 嶺上牌をツモる
                } else {
                    gameData.myDiscards = gameData.decode(str: dict["discards"]!)
                }
            }
        }
        socket.on("Kakan") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myMinkos = gameData.decode(str: dict["minkos"]!)
                    gameData.myMinkans = gameData.decode(str: dict["minkans"]!)
                    socket.emit("Draw", gameData.playerID, true) // 嶺上牌をツモる
                }
            }
        }
        socket.on("Ankan") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myAnkans = gameData.decode(str: dict["ankans"]!)
                    socket.emit("Draw", gameData.playerID, true) // 嶺上牌をツモる
                }
            }
        }
        socket.on("Win") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                score = Int(dict["score"]!)!
                scoreName = dict["scoreName"]!
                let jsonData = dict["hands"]!.data(using: .utf8)!
                hands = try! JSONDecoder().decode(Array<String>.self, from: jsonData)
                canPon = false
                canRon = false
                canRiichi = false
                nextRiichi = false
                isRiichi = false
                isWin = false
                showingScore = true
            }
        }
        socket.on("EndGame") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if dict["winnerID"] == gameData.playerID {
                    gameData.winnerID = gameData.playerID
                    gameData.myScore = Int(dict["winnerScore"]!)!
                    gameData.yourScore = Int(dict["loserScore"]!)!
                } else {
                    gameData.winnerID = gameData.opponentID
                    gameData.yourScore = Int(dict["winnerScore"]!)!
                    gameData.myScore = Int(dict["loserScore"]!)!
                }
                showingEndGame = true
            }
        }
    }
    
    func waitExists() -> Bool {
        var exists = false
        for i in 0..<waitsCandidate.count {
            if (waitsCandidate[i].waitTiles.count != 0) { exists = true }
        }
        return exists
    }
   
    func waitExistsFor(tile: Tile) -> Bool {
        let result: WaitCandidate = waitsCandidate.first(where: { $0.tile.isEqual(tile: tile) })!
        return !result.waitTiles.isEmpty
    }
    
    func canKakanExists() -> Bool {
        var exists = false
        for i in 0..<gameData.myTiles.count {
            if canKakanFor(tile: gameData.myTiles[i]) { exists = true }
        }
        return exists
    }
    
    func canKakanFor(tile: Tile) -> Bool {
        var exists = false
        for i in 0..<gameData.myMinkos.count {
            if (gameData.myMinkos[i].isEqual(tile: tile)) { exists = true }
        }
        return exists
    }
    
    func canAnkanExists() -> Bool {
        var exists = false
        for i in 0..<gameData.myTiles.count {
            if canAnkanFor(tile: gameData.myTiles[i]) { exists = true }
        }
        return exists
    }
    
    func canAnkanFor(tile: Tile) -> Bool {
        var count = 0
        for i in 0..<gameData.myTiles.count {
            if (gameData.myTiles[i].isEqual(tile: tile)) { count += 1 }
        }
        return count == 4
    }
    
    func discardCallback() -> Void {
        isMyTurn = false
        isWin = false
        canRon = false
        canPon = false
        canDaiminkan = false
        canKakan = false
        nextKakan = false
        canAnkan = false
        nextAnkan = false
        canRiichi = false
        nextRiichi = false
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            if gameData.opponentID != "" {
                List {
                    HStack(alignment: .center, spacing: -4, content: {
                        ForEach(0..<13) { _ in
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 60, alignment: .center)
                        }
                    })
                }
                .frame(width: 30*13, height: 70, alignment: .center)
                .listStyle(PlainListStyle())
                .position(x: width/2, y: height*0.1)
                
                Group {
                    Text("\(gameData.yourScore)").position(x: width*0.7, y: height*0.2)
                    Text("\(gameData.opponentID)").position(x: width*0.8, y: height*0.2)
                    Text(!gameData.isParent ? "東" : "南").position(x: width*0.8, y: height*0.25)
                }
            }
            DiscardsView(discards: gameData.yourDiscards, riichiTurn: gameData.yourRiichiTurn)
                .rotationEffect(Angle(degrees: 180.0))
                .position(x: width/2, y: height*0.4)
            Group {
                DoraView().position(x: width*0.2, y: height*0.4)
                Text(gameData.roundWind).position(x: width*0.12, y: height*0.5)
                Text("\(gameData.round)").position(x: width*0.15, y: height*0.5)
                Text("残り \(gameData.stockCount)").position(x: width*0.2, y: height*0.5)
            }
            Button(action: {
                gameService.socket.emit("StartGame")
            }) {
                Text("勝負開始")
            }
            .position(x: width*0.8, y: height*0.5)
            DiscardsView(discards: gameData.myDiscards, riichiTurn: gameData.myRiichiTurn)
                .position(x: width/2, y: height*0.6)
            Group {
                Text(gameData.isParent ? "東" : "南").position(x: width*0.2, y: height*0.7)
                Text("\(gameData.playerID)").position(x: width*0.2, y: height*0.75)
                Text("\(gameData.myScore)").position(x: width*0.3, y: height*0.75)
            }
            Group {
                if (canAnkan && !isRiichi) {
                    Button(action: { nextAnkan.toggle() }) {
                        Text("暗槓")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(nextAnkan ? .blue : .red)
                    }
                    .position(x: width*0.45, y: height*0.8)
                }
                if (canDaiminkan && !isRiichi) {
                    Button(action: {
                        gameService.socket.emit("Daiminkan", gameData.playerID)
                        canDaiminkan = false
                        canPon = false
                    }) {
                        Text("カン")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(.red)
                    }
                    .position(x: width*0.55, y: height*0.8)
                }
                if (canKakan && !isRiichi) {
                    Button(action: { nextKakan.toggle() }) {
                        Text("加槓")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(nextKakan ? .blue : .red)
                    }
                    .position(x: width*0.55, y: height*0.8)
                }
                if (canPon && !isRiichi) {
                    Button(action: {
                        gameService.socket.emit("Pon", gameData.playerID)
                        canPon = false
                    }) {
                        Text("ポン")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(.red)
                    }
                    .position(x: width*0.65, y: height*0.8)
                }
                if (canRon) {
                    Button(action: {
                        gameService.socket.emit("Win", gameData.playerID, "ron")
                    }) {
                        Text("ロン")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(.red)
                    }
                    .position(x: width*0.75, y: height*0.8)
                }
                if (canRiichi && !isRiichi && gameData.isMenzen()) {
                    Button(action: { nextRiichi.toggle() }) {
                        Text("立直")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(nextRiichi ? .blue : .red)
                    }
                    .position(x: width*0.65, y: height*0.8)
                }
                if (isWin) {
                    Button(action: {
                        gameService.socket.emit("Win", gameData.playerID, "draw")
                    }) {
                        Text("ツモ")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(.red)
                    }
                    .position(x: width*0.75, y: height*0.8)
                }
                if (canRon || (canPon && !isRiichi)) {
                    Button(action: {
                        gameService.socket.emit("Draw", gameData.playerID, false)
                        canRon = false
                        canPon = false
                        isWin = false
                    }) {
                        Text("スキップ")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(.gray)
                    }
                    .position(x: width*0.85, y: height*0.8)
                }
                if (isRiichi) {
                    Text("立直中")
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .foregroundColor(.green)
                        .position(x: width*0.85, y: height*0.75)
                }
            }
            
            HStack(alignment: .center, spacing: 0, content: {
                List {
                    HStack(alignment: .center, spacing: -4, content: {
                        ForEach(Array(gameData.myTiles.enumerated()), id: \.offset) { index, tile in
                            Button(action: {
                                if (nextKakan) {
                                    nextKakan.toggle()
                                    canKakan.toggle()
                                    gameService.socket.emit(
                                        "Kakan",
                                        gameData.playerID,
                                        gameData.encode(tiles: [tile])
                                    )
                                    return
                                }
                                if (nextAnkan) {
                                    nextAnkan.toggle()
                                    canAnkan.toggle()
                                    gameService.socket.emit(
                                        "Ankan",
                                        gameData.playerID,
                                        gameData.encode(tiles: [tile])
                                    )
                                    return
                                }
                                if (nextRiichi) {
                                    canRiichi.toggle()
                                    nextRiichi.toggle()
                                    isRiichi = true
                                }
                                gameService.socket.emit(
                                    "Discard",
                                    gameData.playerID,
                                    gameData.encode(tiles: [tile]),
                                    isRiichi
                                )
                                discardCallback()
                            }) {
                                Image(tile.name())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 60, alignment: .center)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(!isMyTurn ||
                                      (nextRiichi && !waitExistsFor(tile: tile)) ||
                                      (isRiichi && index != gameData.myTiles.count - 1) ||
                                      (nextKakan && !canKakanFor(tile: tile)) ||
                                      (nextAnkan && !canAnkanFor(tile: tile))
                            )
                        }
                    })
                }
                .frame(width: 30*13, height: 70, alignment: .center)
                .listStyle(PlainListStyle())
                MinkoView()
                AnkanView()
                MinkanView()
            })
            .position(x: width/2, y: height*0.9)
            
            Group {
                NavigationLink(
                    destination: ScoreView(showingScore: self.$showingScore, score: score, scoreName: scoreName, hands: hands).navigationBarHidden(true),
                    isActive: self.$showingScore
                ) { EmptyView() }
                NavigationLink(
                    destination: EndGameView().navigationBarHidden(true),
                    isActive: self.$showingEndGame
                ) { EmptyView() }
            }
        }
        .onAppear {
            print(gameService.socket.handlers.count)
            if gameService.socket.handlers.count == 0 {
                addHandler(socket: gameService.socket)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameData())
            .environmentObject(GameService())
    }
}
