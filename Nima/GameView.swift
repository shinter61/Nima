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
                    // ここにポン・カン・ロンなどの処理を挟む
                    socket.emit("Draw", gameData.playerID)
                }
            }
        }
        socket.on("DistributeInitTiles") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["id"] {
                    gameData.myTiles = gameData.decode(str: dict["tiles"]!)
                }
            }
        }
        socket.on("Draw") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                gameData.stockCount = Int(dict["stockCount"]!)!
                if gameData.playerID == dict["id"] {
                    let tiles: [Tile] = gameData.decode(str: dict["tiles"]!)
                    gameData.myTiles.append(tiles[0])
                }
            }
        }
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
            DiscardsView(discards: gameData.yourDiscards)
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
            DiscardsView(discards: gameData.myDiscards)
                .position(x: width/2, y: height*0.6)
            Text("\(gameData.playerID)").position(x: width*0.2, y: height*0.8)
            List {
                HStack(alignment: .center, spacing: -4, content: {
                    ForEach(gameData.myTiles, id: \.self) { tile in
                        Button(action: {
                            let myDiscards = gameData.discard(tile: tile)
                            gameService.socket.emit(
                                "Discard",
                                gameData.playerID,
                                gameData.encode(tiles: myDiscards)
                            )
                        }) {
                            Image(tile.name())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 60, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                })
            }
            .frame(width: 30*13, height: 70, alignment: .center)
            .listStyle(PlainListStyle())
            .position(x: width/2, y: height*0.9)
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
