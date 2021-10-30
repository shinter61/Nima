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
    @Binding var rootIsActive: Bool
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
    @State private var showingExhaustive: Bool = false
    @State private var score: Int = 0
    @State private var hands: [String] = []
    @State private var scoreName: String = ""
    @State private var waitsCandidate: [WaitCandidate] = []
    @State private var isFuriten: Bool = false
    
    init(rootIsActive: Binding<Bool>) {
        self._rootIsActive = rootIsActive
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
    }
    
    func addHandler(socket: SocketIOClient!) -> Void {
        socket.on("InformDiscards") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                gameData.kyotaku = Int(dict["kyotaku"]!)!
                if gameData.opponentID == dict["id"] {
                    gameData.yourDiscards = gameData.decode(str: dict["discards"]!)
                    gameData.yourRiichiTurn = Int(dict["riichiTurn"]!)!
                    gameData.yourScore = Int(dict["score"]!)!
                    if gameData.collectToitz().contains(gameData.yourDiscards.last!.name()) {
                        canPon = true
                    }
                    if gameData.collectAnko().contains(gameData.yourDiscards.last!.name()) {
                        canDaiminkan = true
                    }
                    if gameData.myWaits.map({ $0.name() }).contains(gameData.yourDiscards.last!.name()) {
                        canRon = true
                    }
                    if !(canPon && !isRiichi) && !(canRon && !isFuriten) && gameData.stockCount > 0 {
                        socket.emit("Draw", gameData.roomID, gameData.playerID, false)
                    }
                    if gameData.stockCount <= 0 {
                        socket.emit("ExhaustiveDraw", gameData.roomID)
                    }
                }
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myDiscards = gameData.decode(str: dict["discards"]!)
                    gameData.myWaits = gameData.decode(str: dict["waits"]!)
                    gameData.myRiichiTurn = Int(dict["riichiTurn"]!)!
                    gameData.myScore = Int(dict["score"]!)!
                    isFuriten = gameData.isFuriten()
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
                    gameData.yourMinkos = []
                    gameData.yourAnkans = []
                    gameData.yourMinkans = []
                    gameData.yourDiscards = []
                    gameData.myWaits = []
                    gameData.stockCount = Int(dict["stockCount"]!)!
                    gameData.myRiichiTurn = -1
                    gameData.yourRiichiTurn = -1
                    gameData.round = Int(dict["round"]!)!
                    gameData.roundWind = dict["roundWind"]!
                    gameData.honba = Int(dict["honba"]!)!
                    gameData.kyotaku = Int(dict["kyotaku"]!)!
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
                    gameData.yourMinkos = gameData.decode(str: dict["minkos"]!)
                }
            }
        }
        socket.on("Daiminkan") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myMinkans = gameData.decode(str: dict["minkans"]!)
                    gameData.yourDiscards = gameData.decode(str: dict["discards"]!)
                    socket.emit("Draw", gameData.roomID, gameData.playerID, true) // 嶺上牌をツモる
                } else {
                    gameData.myDiscards = gameData.decode(str: dict["discards"]!)
                    gameData.yourMinkans = gameData.decode(str: dict["minkans"]!)
                }
            }
        }
        socket.on("Kakan") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myMinkos = gameData.decode(str: dict["minkos"]!)
                    gameData.myMinkans = gameData.decode(str: dict["minkans"]!)
                    socket.emit("Draw", gameData.roomID, gameData.playerID, true) // 嶺上牌をツモる
                } else {
                    gameData.yourMinkos = gameData.decode(str: dict["minkos"]!)
                    gameData.yourMinkans = gameData.decode(str: dict["minkans"]!)
                }
            }
        }
        socket.on("Ankan") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myAnkans = gameData.decode(str: dict["ankans"]!)
                    socket.emit("Draw", gameData.roomID, gameData.playerID, true) // 嶺上牌をツモる
                } else {
                    gameData.yourAnkans = gameData.decode(str: dict["ankans"]!)
                }
            }
        }
        socket.on("Win") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                gameData.roundWinnerID = dict["id"]!
                if gameData.roundWinnerID == gameData.playerID {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                } else {
                    gameData.yourTiles = gameData.decode(str: dict["tiles"]!)
                }
                score = Int(dict["score"]!)!
                scoreName = dict["scoreName"]!
                let jsonData = dict["hands"]!.data(using: .utf8)!
                hands = try! JSONDecoder().decode(Array<String>.self, from: jsonData)
                gameData.revDoraTiles = gameData.decode(str: dict["revDoras"]!)
                gameData.isGameEnd = (dict["isGameEnd"]! == "true")
                canPon = false
                canRon = false
                canRiichi = false
                nextRiichi = false
                isRiichi = false
                isWin = false
                isFuriten = false
                
                showingScore = true
            }
        }
        socket.on("ExhaustiveDraw") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if dict["id1"]! == gameData.playerID {
                    gameData.myScore = Int(dict["score1"]!)!
                    gameData.yourScore = Int(dict["score2"]!)!
                    gameData.myTiles = gameData.decode(str: dict["tiles1"]!)
                    gameData.myWaits = gameData.decode(str: dict["waitTiles1"]!)
                    gameData.yourTiles = gameData.decode(str: dict["tiles2"]!)
                    gameData.yourWaits = gameData.decode(str: dict["waitTiles2"]!)
                } else if dict["id2"]! == gameData.playerID {
                    gameData.yourScore = Int(dict["score1"]!)!
                    gameData.myScore = Int(dict["score2"]!)!
                    gameData.myTiles = gameData.decode(str: dict["tiles2"]!)
                    gameData.myWaits = gameData.decode(str: dict["waitTiles2"]!)
                    gameData.yourTiles = gameData.decode(str: dict["tiles1"]!)
                    gameData.yourWaits = gameData.decode(str: dict["waitTiles1"]!)
                }
                gameData.isGameEnd = (dict["isGameEnd"]! == "true")
                canPon = false
                canRon = false
                canRiichi = false
                nextRiichi = false
                isRiichi = false
                isWin = false
                isFuriten = false
                
                showingExhaustive = true
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
                gameData.isDisconnected = (dict["isDisconnected"] == "true")
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
            ZStack {
                Colors.init().lightGray.ignoresSafeArea(.all)
                if gameData.opponentID != "" {
                    HStack(alignment: .center, spacing: 0, content: {
                        MinkoView(playerID: gameData.opponentID)
                            .rotationEffect(Angle(degrees: 180.0))
                        AnkanView(playerID: gameData.opponentID)
                            .rotationEffect(Angle(degrees: 180.0))
                        MinkanView(playerID: gameData.opponentID)
                            .rotationEffect(Angle(degrees: 180.0))
                        HStack(alignment: .center, spacing: -4, content: {
                            ForEach(0..<gameData.yourTileCount(), id: \.self) { _ in
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 60, alignment: .center)
                            }
                        })
                        .frame(width: 30*13, height: 70, alignment: .center)
                    })
                    .position(x: width/2, y: height*0.06)
                    
                    Group {
                        NameView(name: "\(gameData.opponentID)").position(x: width*0.8, y: height*0.2)
                        WindView(wind: !gameData.isParent ? "東" : "南").position(x: width*0.8, y: height*0.29)
                    }
                }
                DiscardsView(discards: gameData.yourDiscards, riichiTurn: gameData.yourRiichiTurn)
                    .rotationEffect(Angle(degrees: 180.0))
                    .position(x: width*0.47, y: height*0.28)
                Group {
                    CustomText(content: "\(gameData.yourScore)", size: 24, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                        .position(x: width*0.34, y: height*0.44)
                    DoraView().position(x: width*0.2, y: height*0.3)
                    GameInfoView()
                        .position(x: width*0.5, y: height*0.5)
                    SubGameInfoView()
                        .position(x: width*0.7, y: height*0.5)
                    CustomText(content: "\(gameData.myScore)", size: 24, tracking: 0)
                        .foregroundColor(Colors.init().red)
                        .position(x: width*0.34, y: height*0.56)
                }
                DiscardsView(discards: gameData.myDiscards, riichiTurn: gameData.myRiichiTurn)
                    .position(x: width*0.53, y: height*0.72)
                Group {
                    WindView(wind: gameData.isParent ? "東" : "南").position(x: width*0.2, y: height*0.66)
                    if isFuriten {
                        FuritenView().position(x: width*0.3, y: height*0.66)
                    }
                    NameView(name: "\(gameData.playerID)").position(x: width*0.2, y: height*0.75)
                }
                Group {
                    if (canAnkan && !isRiichi) {
                        Button(action: { nextAnkan.toggle() }) {
                            CustomText(content: "暗槓", size: 24, tracking: 0)
                                .foregroundColor(nextAnkan ? Colors.init().navy : Colors.init().red)
                        }
                        .position(x: width*0.45, y: height*0.8)
                    }
                    if (canDaiminkan && !isRiichi) {
                        Button(action: {
                            gameService.socket.emit("Daiminkan", gameData.roomID, gameData.playerID)
                            canDaiminkan = false
                            canPon = false
                        }) {
                            CustomText(content: "カン", size: 24, tracking: 0)
                                .foregroundColor(Colors.init().red)
                        }
                        .position(x: width*0.55, y: height*0.8)
                    }
                    if (canKakan && !isRiichi) {
                        Button(action: { nextKakan.toggle() }) {
                            CustomText(content: "加槓", size: 24, tracking: 0)
                                .foregroundColor(nextKakan ? Colors.init().navy : Colors.init().red)
                        }
                        .position(x: width*0.55, y: height*0.8)
                    }
                    if (canPon && !isRiichi) {
                        Button(action: {
                            gameService.socket.emit("Pon", gameData.roomID, gameData.playerID)
                            canPon = false
                        }) {
                            CustomText(content: "ポン", size: 24, tracking: 0)
                                .foregroundColor(Colors.init().red)
                        }
                        .position(x: width*0.65, y: height*0.8)
                    }
                    if (!isFuriten && canRon) {
                        Button(action: {
                            gameService.socket.emit("Win", gameData.roomID, gameData.playerID, "ron")
                        }) {
                            CustomText(content: "ロン", size: 24, tracking: 0)
                                .foregroundColor(Colors.init().red)
                        }
                        .position(x: width*0.75, y: height*0.8)
                    }
                    if (canRiichi && !isRiichi && gameData.isMenzen()) {
                        Button(action: { nextRiichi.toggle() }) {
                            CustomText(content: "立直", size: 24, tracking: 0)
                                .foregroundColor(nextRiichi ? Colors.init().navy : Colors.init().red)
                        }
                        .position(x: width*0.65, y: height*0.8)
                    }
                    if (isWin) {
                        Button(action: {
                            gameService.socket.emit("Win", gameData.roomID, gameData.playerID, "draw")
                        }) {
                            CustomText(content: "ツモ", size: 24, tracking: 0)
                                .foregroundColor(Colors.init().red)
                        }
                        .position(x: width*0.75, y: height*0.8)
                    }
                    if ((canRon && !isFuriten) || (canPon && !isRiichi)) {
                        Button(action: {
                            gameService.socket.emit("Draw", gameData.roomID, gameData.playerID, false)
                            canRon = false
                            canPon = false
                            isWin = false
                        }) {
                            CustomText(content: "スキップ", size: 24, tracking: 0)
                                .foregroundColor(.gray)
                        }
                        .position(x: width*0.85, y: height*0.8)
                    }
                }
            }
            .rotation3DEffect(Angle(degrees: 10.0),
                              axis: (x: 10, y: 0, z: 0),
                              anchorZ: -30,
                              perspective: 1)
            HStack(alignment: .center, spacing: 0, content: {
                HStack(alignment: .center, spacing: -6, content: {
                    ForEach(Array(gameData.myTiles.enumerated()), id: \.offset) { index, tile in
                        Button(action: {
                            if (nextKakan) {
                                nextKakan.toggle()
                                canKakan.toggle()
                                gameService.socket.emit(
                                    "Kakan",
                                    gameData.roomID,
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
                                    gameData.roomID,
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
                                gameData.roomID,
                                gameData.playerID,
                                gameData.encode(tiles: [tile]),
                                isRiichi
                            )
                            discardCallback()
                        }) {
                            Image(tile.name())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 60, alignment: .center)
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
                    .padding(.trailing, 6)
                MinkoView(playerID: gameData.playerID)
                AnkanView(playerID: gameData.playerID)
                MinkanView(playerID: gameData.playerID)
            })
            .position(x: width/2, y: height*0.93)
            
            Group {
                NavigationLink(
                    destination: ExhaustiveDrawView(rootIsActive: self.$rootIsActive).navigationBarHidden(true),
                    isActive: self.$showingExhaustive
                ) { EmptyView() }
                NavigationLink(
                    destination: ScoreView(rootIsActive: self.$rootIsActive, score: score, scoreName: scoreName, hands: hands).navigationBarHidden(true),
                    isActive: self.$showingScore
                ) { EmptyView() }
                NavigationLink(
                    destination: EndGameView(rootIsActive: self.$rootIsActive).navigationBarHidden(true),
                    isActive: self.$showingEndGame
                ) { EmptyView() }
            }
        }
        .onAppear {
            if gameService.socket.handlers.count == 2 {
                addHandler(socket: gameService.socket)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            GameView(rootIsActive: .constant(false))
                .environmentObject(GameData())
                .environmentObject(GameService())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
