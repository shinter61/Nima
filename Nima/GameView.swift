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
                gameData.opponentID = dict["player2"]!
            }
            if let hash = data[0] as? [String: String], gameData.playerID == hash["player2"] {
                gameData.opponentID = hash["player1"]!
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            Text("\(gameData.opponentID)").position(x: width*0.2, y: height*0.2)
            Text("残り \(gameData.stock.count)")
                .position(x: width/2, y: height*0.4)
            DiscardsView(discards: gameData.myDiscards)
            .position(x: width/2, y: height*0.6)
            
            Text("\(gameData.playerID)").position(x: width*0.2, y: height*0.8)
            Button(action: {
                gameData.draw()
            }) {
                Text("ツモる")
            }.position(x: width*0.9, y: height*0.8)
            List {
                HStack(alignment: .center, spacing: -4, content: {
                    ForEach(gameData.myTiles, id: \.self) { tile in
                        Button(action: {
                            let myDiscards = gameData.discard(tile: tile)
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
            gameData.reload()
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
