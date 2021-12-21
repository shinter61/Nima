//
//  GameView.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI
import SocketIO

struct Hand: Hashable, Codable {
    var name: String
    var han: Int
}

struct GameView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var soundData: SoundData
    @EnvironmentObject var gameService: GameService
    @Binding var rootIsActive: Bool
    @State private var isMyTurn: Bool = false
    @State private var isWin: Bool = false
    @State private var isWon: Bool = false
    @State private var canRon: Bool = false
    @State private var canPon: Bool = false
    @State private var canDaiminkan: Bool = false
    @State private var canKakan: Bool = false
    @State private var nextKakan: Bool = false
    @State private var nextAnkan: Bool = false
    @State private var canRiichi: Bool = false
    @State private var nextRiichi: Bool = false
    @State private var isRiichi: Bool = false
    @State private var showingScore: Bool = false
    @State private var showingEndGame: Bool = false
    @State private var showingExhaustive: Bool = false
    @State private var showingWinNotice: Bool = false
    @State private var score: Int = 0
    @State private var hands: [Hand] = []
    @State private var scoreName: String = ""
    @State private var waitsCandidate: [WaitCandidate] = []
    @State private var isFuriten: Bool = false
    
    @State private var isOpponentDraw: Bool = false
    @State private var opponentDiscardTimer: Timer!
    @State private var opponentDiscardCountdown: Int = 500
    @State private var isTedashi: Bool = false
    
    @State private var myActionTimer: Timer!
    @State private var myActionCountdown: Int = 5
    @State private var myDiscardTimer: Timer!
    @State private var myDiscardCountdown: Int = 20
    
    init(rootIsActive: Binding<Bool>) {
        self._rootIsActive = rootIsActive
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
    }
    
    func addHandler(socket: SocketIOClient!) -> Void {
        socket.on("InformDiscards") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                soundData.discardSound.play()
                gameData.kyotaku = Int(dict["kyotaku"]!)!
                if gameData.opponentID == Int(dict["id"]!) {
                    isOpponentDraw = false
                    isTedashi = (dict["isTedashi"] == "true")
                    
                    startOpponentTimer()
                    
                    gameData.yourDiscards = gameData.decode(str: dict["discards"]!)
                    if gameData.yourRiichiTurn == -1 && Int(dict["riichiTurn"]!) != -1 {
                        soundData.riichiSound.play()
                    }
                    gameData.yourRiichiTurn = Int(dict["riichiTurn"]!)!
                    gameData.yourScore = Int(dict["score"]!)!
                    if gameData.collectToitz().contains(gameData.yourDiscards.last!.name()) {
                        canPon = true
                    }
                    if gameData.collectAnko().contains(gameData.yourDiscards.last!.name()) {
                        canDaiminkan = true
                    }
                    if gameData.myRonWaits.map({ $0.name() }).contains(gameData.yourDiscards.last!.name()) {
                        canRon = true
                    }
                    if !(canPon && !isRiichi) && !(canRon && !isFuriten) && gameData.stockCount > 0 {
                        socket.emit("Draw", gameData.roomID, userData.userID, false)
                    } else if gameData.stockCount <= 0 && !(canRon && !isFuriten) {
                        socket.emit("ExhaustiveDraw", gameData.roomID)
                    } else {
                        startMyActionTimer()
                    }
                }
                if userData.userID == Int(dict["id"]!) {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myDiscards = gameData.decode(str: dict["discards"]!)
                    gameData.myDrawWaits = gameData.decode(str: dict["drawWaits"]!)
                    gameData.myRonWaits = gameData.decode(str: dict["ronWaits"]!)
                    if gameData.myRiichiTurn == -1 && Int(dict["riichiTurn"]!) != -1 {
                        soundData.riichiSound.play()
                    }
                    gameData.myRiichiTurn = Int(dict["riichiTurn"]!)!
                    gameData.myScore = Int(dict["score"]!)!
                    isFuriten = gameData.isFuriten()
                }
            }
        }
        socket.on("DistributeInitTiles") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if userData.userID == Int(dict["id"]!) {
                    soundData.ripaiSound.play()
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myScore = Int(dict["score"]!)!
                    gameData.myMinkos = []
                    gameData.myAnkans = []
                    gameData.myMinkans = []
                    gameData.myDiscards = []
                    gameData.yourTiles = []
                    gameData.yourMinkos = []
                    gameData.yourAnkans = []
                    gameData.yourMinkans = []
                    gameData.yourDiscards = []
                    gameData.yourWaits = []
                    gameData.myDrawWaits = []
                    gameData.myRonWaits = []
                    gameData.canAnkanTiles = []
                    gameData.stockCount = Int(dict["stockCount"]!)!
                    gameData.myRiichiTurn = -1
                    gameData.yourRiichiTurn = -1
                    gameData.round = Int(dict["round"]!)!
                    gameData.roundWind = dict["roundWind"]!
                    gameData.honba = Int(dict["honba"]!)!
                    gameData.kyotaku = Int(dict["kyotaku"]!)!
                    gameData.isParent = (dict["isParent"] == "true")
                    gameData.doraTiles = gameData.decode(str: dict["doraTiles"]!)
                    gameData.roundWinnerID = -1
                    gameData.roundWinType = ""
                    isWon = false
                    
                    if (gameData.isParent) {
                        socket.emit("Draw", gameData.roomID, userData.userID, false)
                    }
                } else {
                    gameData.yourScore = Int(dict["score"]!)!
                }
                
            }
        }
        socket.on("Draw") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                gameData.stockCount = Int(dict["stockCount"]!)!
                gameData.doraTiles = gameData.decode(str: dict["doraTiles"]!)
                if userData.userID == Int(dict["id"]!) {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    if (gameData.isMyTurn()) { isMyTurn = true }
                    if (dict["isWin"] == "true") { isWin = true }
                    waitsCandidate = gameData.decodeWaitsCandidate(str: dict["waitsCandidate"]!)
                    if waitExists() && gameData.myScore >= 1000 { canRiichi = true }
                    if canKakanExists() { canKakan = true }
                    gameData.canAnkanTiles = gameData.decode(str: dict["canAnkanTiles"]!)
                    
                    if isRiichi && !isWin && gameData.canAnkanTiles.count == 0 { myDiscardCountdown = 1 }
                    
                    startMyDiscardTimer()
                } else if gameData.opponentID == Int(dict["id"]!) {
                    isOpponentDraw = true
                }
            }
        }
        socket.on("Pon") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                soundData.ponSound.play()
                if userData.userID == Int(dict["id"]!) {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myMinkos = gameData.decode(str: dict["minkos"]!)
                    gameData.yourDiscards = gameData.decode(str: dict["discards"]!)
                    if (gameData.isMyTurn()) { isMyTurn = true }
                    startMyDiscardTimer()
                } else {
                    gameData.myDiscards = gameData.decode(str: dict["discards"]!)
                    gameData.yourMinkos = gameData.decode(str: dict["minkos"]!)
                }
            }
        }
        socket.on("Daiminkan") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                soundData.kanSound.play()
                if userData.userID == Int(dict["id"]!) {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myMinkans = gameData.decode(str: dict["minkans"]!)
                    gameData.yourDiscards = gameData.decode(str: dict["discards"]!)
                    socket.emit("Draw", gameData.roomID, userData.userID, true) // 嶺上牌をツモる
                } else {
                    gameData.myDiscards = gameData.decode(str: dict["discards"]!)
                    gameData.yourMinkans = gameData.decode(str: dict["minkans"]!)
                }
            }
        }
        socket.on("Kakan") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                soundData.kanSound.play()
                if userData.userID == Int(dict["id"]!) {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myMinkos = gameData.decode(str: dict["minkos"]!)
                    gameData.myMinkans = gameData.decode(str: dict["minkans"]!)
                    socket.emit("Draw", gameData.roomID, userData.userID, true) // 嶺上牌をツモる
                } else {
                    gameData.yourMinkos = gameData.decode(str: dict["minkos"]!)
                    gameData.yourMinkans = gameData.decode(str: dict["minkans"]!)
                }
            }
        }
        socket.on("Ankan") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                soundData.kanSound.play()
                if userData.userID == Int(dict["id"]!) {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                    gameData.myAnkans = gameData.decode(str: dict["ankans"]!)
                    socket.emit("Draw", gameData.roomID, userData.userID, true) // 嶺上牌をツモる
                } else {
                    gameData.yourAnkans = gameData.decode(str: dict["ankans"]!)
                }
            }
        }
        socket.on("Win") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                gameData.roundWinnerID = Int(dict["id"]!)!
                if gameData.roundWinnerID == userData.userID {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                } else {
                    gameData.yourTiles = gameData.decode(str: dict["tiles"]!)
                }
                score = Int(dict["score"]!)!
                scoreName = dict["scoreName"]!
                let jsonData = dict["hands"]!.data(using: .utf8)!
                hands = try! JSONDecoder().decode(Array<Hand>.self, from: jsonData)
                gameData.revDoraTiles = gameData.decode(str: dict["revDoras"]!)
                gameData.roundWinType = (dict["winType"]! == "draw" ? "ツモ" : "ロン")
                gameData.isGameEnd = (dict["isGameEnd"]! == "true")
                canPon = false
                canRon = false
                canDaiminkan = false
                canKakan = false
                nextKakan = false
                nextAnkan = false
                canRiichi = false
                nextRiichi = false
                isRiichi = false
                isWin = false
                isFuriten = false
                
                showingWinNotice = true
                
                dict["winType"]! == "draw" ? soundData.tsumoSound.play() : soundData.ronSound.play()
            }
        }
        socket.on("ExhaustiveDraw") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if Int(dict["id1"]!) == userData.userID {
                    gameData.myScore = Int(dict["score1"]!)!
                    gameData.yourScore = Int(dict["score2"]!)!
                    gameData.myTiles = gameData.decode(str: dict["tiles1"]!)
                    gameData.myDrawWaits = gameData.decode(str: dict["waitTiles1"]!)
                    gameData.yourTiles = gameData.decode(str: dict["tiles2"]!)
                    gameData.yourWaits = gameData.decode(str: dict["waitTiles2"]!)
                } else if Int(dict["id2"]!) == userData.userID {
                    gameData.yourScore = Int(dict["score1"]!)!
                    gameData.myScore = Int(dict["score2"]!)!
                    gameData.myTiles = gameData.decode(str: dict["tiles2"]!)
                    gameData.myDrawWaits = gameData.decode(str: dict["waitTiles2"]!)
                    gameData.yourTiles = gameData.decode(str: dict["tiles1"]!)
                    gameData.yourWaits = gameData.decode(str: dict["waitTiles1"]!)
                }
                gameData.isGameEnd = (dict["isGameEnd"]! == "true")
                canPon = false
                canRon = false
                canDaiminkan = false
                canKakan = false
                nextKakan = false
                nextAnkan = false
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
                if Int(dict["winnerID"]!) == userData.userID {
                    gameData.winnerID = userData.userID
                    gameData.myScore = Int(dict["winnerScore"]!)!
                    gameData.yourScore = Int(dict["loserScore"]!)!
                } else {
                    gameData.winnerID = gameData.opponentID
                    gameData.yourScore = Int(dict["winnerScore"]!)!
                    gameData.myScore = Int(dict["loserScore"]!)!
                }
                gameData.isDisconnected = (dict["isDisconnected"] == "true")
                if gameData.isDisconnected { showingEndGame = true } // 接続切れのみゲーム画面から終局に移行する
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
    
    func canAnkanFor(tile: Tile) -> Bool {
        var exists = false
        for i in 0..<gameData.canAnkanTiles.count {
            if (gameData.canAnkanTiles[i].isEqual(tile: tile)) { exists = true }
        }
        return exists
    }
    
    func discardCallback() -> Void {
        isMyTurn = false
        isWin = false
        canRon = false
        canPon = false
        canDaiminkan = false
        canKakan = false
        nextKakan = false
        nextAnkan = false
        canRiichi = false
        nextRiichi = false
    }
    
    func skipAction() -> Void {
        if gameData.stockCount > 0 {
            gameService.socket.emit("Draw", gameData.roomID, userData.userID, false)
            canRon = false
            canPon = false
            canDaiminkan = false
            isWin = false
        } else {
            gameService.socket.emit("ExhaustiveDraw", gameData.roomID)
        }
    }
    
    func startOpponentTimer() -> Void {
        let startTime: Date = Date()
        opponentDiscardTimer?.invalidate()
        opponentDiscardTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { _ in
            let current = Date()
            let diff = (Calendar.current.dateComponents([.nanosecond], from: startTime, to: current)).nanosecond! / 1000000
            if diff >= 500 { self.opponentDiscardTimer?.invalidate() }
            self.opponentDiscardCountdown = 500 - diff
        })
    }
    
    func callBackOpponentTimer() -> Void {
        opponentDiscardCountdown = 500
        isTedashi = false
    }
    
    func startMyActionTimer() -> Void {
        let startTime: Date = Date()
        myActionTimer?.invalidate()
        myActionTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { _ in
            let current = Date()
            let diff = (Calendar.current.dateComponents([.second], from: startTime, to: current)).second!
            if diff >= 5 { self.myActionTimer?.invalidate() }
            self.myActionCountdown = 5 - diff
        })
    }
    
    func callBackMyActionTimer() -> Void {
        resetMyActionTimer()
        skipAction()
    }
    
    func resetMyActionTimer() -> Void {
        myActionTimer?.invalidate()
        myActionCountdown = 5
    }
    
    func resetMyDiscardTimer() -> Void {
        myDiscardTimer?.invalidate()
        myDiscardCountdown = isRiichi && !isWin && gameData.canAnkanTiles.count == 0 ? 1 : 20
    }
    
    func startMyDiscardTimer() -> Void {
        let myDiscardLimit = isRiichi && !isWin && gameData.canAnkanTiles.count == 0 ? 1 : 20
        let startTime: Date = Date()
        myDiscardTimer?.invalidate()
        myDiscardTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { _ in
            let current = Date()
            let diff = (Calendar.current.dateComponents([.second], from: startTime, to: current)).second!
            if diff >= myDiscardLimit { self.myDiscardTimer?.invalidate() }
            self.myDiscardCountdown = myDiscardLimit - diff
        })
    }
    
    func callBackMyDiscardTimer() -> Void {
        resetMyDiscardTimer()
        
        let lastTile: Tile = gameData.myTiles[gameData.myTiles.count - 1]
        gameService.socket.emit(
            "Discard",
            gameData.roomID,
            userData.userID,
            gameData.encode(tiles: [lastTile]),
            isRiichi
        )
        discardCallback()
    }
    
    func ron() -> Void {
        resetMyActionTimer()
        gameService.socket.emit("Win", gameData.roomID, userData.userID, "ron")
        isWon = true
    }
    
    func draw() -> Void {
        resetMyDiscardTimer()
        gameService.socket.emit("Win", gameData.roomID, userData.userID, "draw")
        isWon = true
    }
    
    func discard(tile: Tile, index: Int) -> Void {
        if (!isMyTurn ||
           (nextRiichi && !waitExistsFor(tile: tile)) ||
           (nextKakan && !canKakanFor(tile: tile)) ||
           (isRiichi && ((!nextAnkan && index != gameData.myTiles.count - 1) || (nextAnkan && !canAnkanFor(tile: tile)))) ||
           (!isRiichi && nextAnkan && !canAnkanFor(tile: tile)) ||
            isWon) { return }
        if (nextKakan) {
            nextKakan.toggle()
            canKakan.toggle()
            gameService.socket.emit(
                "Kakan",
                gameData.roomID,
                userData.userID,
                gameData.encode(tiles: [tile])
            )
            return
        }
        if (nextAnkan) {
            nextAnkan.toggle()
            gameService.socket.emit(
                "Ankan",
                gameData.roomID,
                userData.userID,
                gameData.encode(tiles: [tile])
            )
            return
        }
        if (nextRiichi) {
            canRiichi.toggle()
            nextRiichi.toggle()
            isRiichi = true
        }
        resetMyDiscardTimer()
        gameService.socket.emit(
            "Discard",
            gameData.roomID,
            userData.userID,
            gameData.encode(tiles: [tile]),
            isRiichi
        )
        discardCallback()
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                ZStack {
                    Colors.init().lightGray.ignoresSafeArea(.all)
                    if gameData.opponentID != -1 {
                        HStack(alignment: .center, spacing: 0, content: {
                            MinkoView(playerID: gameData.opponentID)
                                .rotationEffect(Angle(degrees: 180.0))
                            AnkanView(playerID: gameData.opponentID)
                                .rotationEffect(Angle(degrees: 180.0))
                            MinkanView(playerID: gameData.opponentID)
                                .rotationEffect(Angle(degrees: 180.0))
                            if isOpponentDraw {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 60, alignment: .center)
                                    .padding(.leading, 10)
                            }
                            HStack(alignment: .center, spacing: -4, content: {
                                ForEach(0..<gameData.yourTileCount(), id: \.self) { index in
                                    if isTedashi && index == gameData.tedashiIndex() && opponentDiscardCountdown > 0 {
                                        Rectangle()
                                            .foregroundColor(Colors.init().lightGray)
                                            .frame(width: 30, height: 60, alignment: .center)
                                    } else {
                                        Image("back")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 60, alignment: .center)
                                    }
                                }
                            })
                            .frame(width: CGFloat(28*gameData.yourTileCount()), height: 70, alignment: .center)
                        })
                        .position(x: width/2, y: height*0.06)
                        
                        Group {
                            NameView(name: gameData.opponentName).position(x: width*0.8, y: height*0.2)
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
                        NameView(name: userData.userName).position(x: width*0.2, y: height*0.75)
                    }
                    Group {
                        if (isMyTurn && gameData.canAnkanTiles.count != 0 && gameData.stockCount >= 1) {
                            Button(action: { nextAnkan.toggle() }) {
                                CustomText(content: "暗槓", size: 24, tracking: 0)
                                    .foregroundColor(nextAnkan ? Colors.init().navy : Colors.init().red)
                            }
                            .position(x: width*0.45, y: height*0.8)
                        }
                        if (canDaiminkan && !isRiichi) {
                            Button(action: {
                                resetMyActionTimer()
                                gameService.socket.emit("Daiminkan", gameData.roomID, userData.userID)
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
                                resetMyActionTimer()
                                gameService.socket.emit("Pon", gameData.roomID, userData.userID)
                                canPon = false
                            }) {
                                CustomText(content: "ポン", size: 24, tracking: 0)
                                    .foregroundColor(Colors.init().red)
                            }
                            .position(x: width*0.65, y: height*0.8)
                        }
                        if (!isFuriten && canRon) {
                            CustomText(content: "ロン", size: 24, tracking: 0)
                                .foregroundColor(Colors.init().red)
                                .onTapGesture(count: 3) { ron() }
                                .onTapGesture(count: 2) { ron() }
                                .onTapGesture(count: 1) { ron() }
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
                            CustomText(content: "ツモ", size: 24, tracking: 0)
                                .foregroundColor(Colors.init().red)
                                .onTapGesture(count: 3) { draw() }
                                .onTapGesture(count: 2) { draw() }
                                .onTapGesture(count: 1) { draw() }
                                .position(x: width*0.75, y: height*0.8)
                        }
                        if ((canRon && !isFuriten) || (canPon && !isRiichi)) {
                            Button(action: {
                                if canRon { isFuriten = true }
                                resetMyActionTimer()
                                skipAction()
                            }) {
                                CustomText(content: "スキップ", size: 24, tracking: 0)
                                    .foregroundColor(.gray)
                            }
                            .position(x: width*0.85, y: height*0.8)
                        }
                    }
                    if ((canPon && !isRiichi) || (canRon && !isFuriten)) && !isMyTurn && myActionCountdown > 0 {
                        CustomText(content: "\(myActionCountdown)", size: 28, tracking: 0)
                            .foregroundColor(Colors.init().navy)
                            .position(x: width*0.85, y: height*0.65)
                    } else if isMyTurn && myDiscardCountdown > 0 {
                        CustomText(content: "\(myDiscardCountdown)", size: 28, tracking: 0)
                            .foregroundColor(Colors.init().navy)
                            .position(x: width*0.85, y: height*0.65)
                    }
                }
                .rotation3DEffect(Angle(degrees: 10.0),
                                  axis: (x: 10, y: 0, z: 0),
                                  anchorZ: -30,
                                  perspective: 1)
                HStack(alignment: .center, spacing: 0, content: {
                    HStack(alignment: .center, spacing: -6, content: {
                        ForEach(Array(gameData.myTiles.enumerated()), id: \.offset) { index, tile in
                            ZStack {
                                Image(tile.name())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 60, alignment: .center)
                                if gameData.doraTiles.map { $0.next().name() }.contains(tile.name()) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.yellow.opacity(0.2))
                                        .frame(width: 30, height: 45, alignment: .center)
                                }
                                if (!isMyTurn ||
                                   (nextRiichi && !waitExistsFor(tile: tile)) ||
                                   (nextKakan && !canKakanFor(tile: tile)) ||
                                   (isRiichi && ((!nextAnkan && index != gameData.myTiles.count - 1) || (nextAnkan && !canAnkanFor(tile: tile)))) ||
                                   (!isRiichi && nextAnkan && !canAnkanFor(tile: tile)) ||
                                    isWon) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Colors().lightGray.opacity(0.7))
                                        .frame(width: 32, height: 47, alignment: .center)
                                }
                            }
                            .padding(.leading, index == (13 - gameData.myAnkans.count*3 - gameData.myMinkans.count*3 - gameData.myMinkos.count*3) ? 6.0 : 0.0)
                            .onTapGesture(count: 2) { discard(tile: tile, index: index) }
                        }
                    })
                        .padding(.leading, width*0.1)
                    Spacer()
                    Group {
                        MinkoView(playerID: userData.userID)
                        AnkanView(playerID: userData.userID)
                        MinkanView(playerID: userData.userID)
                    }
                        .padding(.trailing, width*0.03)
                })
                .position(x: width/2, y: height*0.93)
                
                if self.showingWinNotice {
                    WinNoticeView(
                        showingWinNotice: self.$showingWinNotice,
                        showingScore: self.$showingScore,
                        content: gameData.roundWinType
                    )
                    .position(
                        x: width/2,
                        y: gameData.roundWinnerID == userData.userID ?  height*0.7 : height*0.3
                    )
                }
                if self.opponentDiscardCountdown <= 0 {
                    ActionEmptyView(action: callBackOpponentTimer)
                }
                if self.myActionCountdown <= 0 {
                    ActionEmptyView(action: callBackMyActionTimer)
                }
                if self.myDiscardCountdown <= 0 {
                    ActionEmptyView(action: callBackMyDiscardTimer)
                }
            }
            
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
                .environmentObject(UserData())
                .environmentObject(GameService())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
