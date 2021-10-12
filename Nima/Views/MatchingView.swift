//
//  MatchingView.swift
//  MatchingView
//
//  Created by 松本真太朗 on 2021/10/12.
//

import SwiftUI
import SocketIO

struct MatchingView: View {
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var gameService: GameService
    @State private var matchingFinished: Bool = false
    func addHandler(socket: SocketIOClient!) -> Void {
        socket.on(clientEvent: .connect) { (data, ack) in
            socket.emit("StartMatching", gameData.playerID)
        }
        socket.on("InformPlayersNames") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                if gameData.playerID == dict["player1"] {
                    gameData.opponentID = dict["player2"]!
                }
                if gameData.playerID == dict["player2"] {
                    gameData.opponentID = dict["player1"]!
                }
                matchingFinished = true
            }
        }
    }
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                Colors.init().navy.ignoresSafeArea(.all)
                CustomText(content: "マッチング中...", size: 32, tracking: 0)
                    .foregroundColor(Color.white)
                    .position(x: width*0.5, y: height*0.3)
                ProgressView()
                    .scaleEffect(x: 2, y: 2, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .position(x: width*0.5, y: height*0.7)
            }
            
            NavigationLink(
                destination: GameView().navigationBarHidden(true),
                isActive: self.$matchingFinished
            ) { EmptyView() }
        }
        .onAppear {
            addHandler(socket: gameService.socket)
            let from = gameData.playerID.index(gameData.playerID.startIndex, offsetBy: 0)
            let to = gameData.playerID.index(gameData.playerID.startIndex, offsetBy: 8)
            gameData.playerID = String(gameData.playerID[from..<to])
            gameService.socket.connect(withPayload: ["name": gameData.playerID])
        }
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingView()
            .environmentObject(GameData())
            .environmentObject(GameService())
    }
}
