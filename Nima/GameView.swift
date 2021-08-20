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
    @State private var canRiichi: Bool = false
    @State private var nextRiichi: Bool = false
    @State private var isRiichi: Bool = false
    @State private var showingScore: Bool = false
    @State private var score: Int = 0
    @State private var hands: [String] = []
    @State private var scoreName: String = ""
    @State private var waitsCandidate: [WaitCandidate] = []
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
    }
    
    func addHandler(socket: SocketIOClient!) -> Void {
        socket.on(clientEvent: .connect) { (data, ack) in
            socket.emit("AddPlayer", gameData.playerID)
        }
        socket.on("InformPlayersNames") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["player1"] {
                    gameData.opponentID = dict["player2"]!
                }
            }
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["player2"] {
                    gameData.opponentID = dict["player1"]!
                }
            }
        }
        socket.on("InformDiscards") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.opponentID == dict["id"] {
                    gameData.yourDiscards = gameData.decode(str: dict["discards"]!)
                    gameData.yourRiichiTurn = Int(dict["riichiTurn"]!)!
                    if gameData.collectToitz().contains(gameData.yourDiscards.last!.name()) {
                        canPon = true
                    }
                    if gameData.myWaits.map({ $0.name() }).contains(gameData.yourDiscards.last!.name()) {
                        canRon = true
                    }
                    if !canPon && !canRon {
                        socket.emit("Draw", gameData.playerID)
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
                    
                    if (gameData.myTiles.count == 14) { isMyTurn = true }
                }
            }
        }
        socket.on("Draw") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                gameData.stockCount = Int(dict["stockCount"]!)!
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    if (gameData.myTiles.count + gameData.myMinkos.count*3 == 14) { isMyTurn = true }
                    if (dict["isWin"] == "true") { isWin = true }
                    waitsCandidate = gameData.decodeWaitsCandidate(str: dict["waitsCandidate"]!)
                    if (waitExists()) { canRiichi = true }
                }
            }
        }
        socket.on("Pon") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myMinkos = gameData.decode(str: dict["minkos"]!)
                    gameData.yourDiscards = gameData.decode(str: dict["discards"]!)
                    if (gameData.myTiles.count + gameData.myMinkos.count*3 == 14) { isMyTurn = true }
                } else {
                    gameData.myDiscards = gameData.decode(str: dict["discards"]!)
                }
            }
        }
        socket.on("Win") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                score = Int(dict["score"]!)!
                scoreName = dict["scoreName"]!
                let jsonData = dict["hands"]!.data(using: .utf8)!
                hands = try! JSONDecoder().decode(Array<String>.self, from: jsonData)
                showingScore = true
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
                
                Text("\(gameData.opponentID)").position(x: width*0.8, y: height*0.2)
            }
            DiscardsView(discards: gameData.yourDiscards, riichiTurn: gameData.yourRiichiTurn)
                .rotationEffect(Angle(degrees: 180.0))
                .position(x: width/2, y: height*0.4)
            Text("残り \(gameData.stockCount)")
                .position(x: width*0.2, y: height*0.5)
            Button(action: {
                gameService.socket.emit("StartGame")
            }) {
                Text("勝負開始")
            }
            .position(x: width*0.8, y: height*0.5)
            DiscardsView(discards: gameData.myDiscards, riichiTurn: gameData.myRiichiTurn)
                .position(x: width/2, y: height*0.6)
            Text("\(gameData.playerID)").position(x: width*0.2, y: height*0.75)
            Group {
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
                        gameService.socket.emit("Draw", gameData.playerID)
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
                                isMyTurn = false
                            }) {
                                Image(tile.name())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 60, alignment: .center)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(!isMyTurn || (nextRiichi && !waitExistsFor(tile: tile)) || (isRiichi && index != gameData.myTiles.count - 1))
                        }
                    })
                }
                .frame(width: 30*13, height: 70, alignment: .center)
                .listStyle(PlainListStyle())
                MinkoView()
            })
            .position(x: width/2, y: height*0.9)
            
            NavigationLink(
                destination: ScoreView(score: score, scoreName: scoreName, hands: hands).navigationBarHidden(true),
                isActive: self.$showingScore
            ) { EmptyView() }
        }
        .onAppear {
            addHandler(socket: gameService.socket)
            gameService.socket.connect(withPayload: ["name": gameData.playerID])
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameData())
    }
}
