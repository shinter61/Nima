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
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var gameService: GameService
    @Binding var rootIsActive: Bool
    @State private var matchingFinished: Bool = false
    func addHandler(socket: SocketIOClient!) -> Void {
        gameData.playerID = userData.playerID
        socket.on(clientEvent: .connect) { (data, ack) in
            socket.emit("StartMatching", gameData.playerID)
        }
        socket.on("InformPlayersNames") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                gameData.roomID = dict["roomID"]!
                if gameData.playerID == dict["player1"] {
                    gameData.opponentID = dict["player2"]!
                    gameService.socket.emit("StartGame", gameData.roomID) // StartGameは2台につき1台からのみ発行
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
                destination: GameView(rootIsActive: self.$rootIsActive).navigationBarHidden(true),
                isActive: self.$matchingFinished
            ) { EmptyView() }
        }
        .onAppear {
            if gameService.socket.handlers.count == 0 {
                addHandler(socket: gameService.socket)
            }
            gameService.socket.connect(withPayload: ["name": gameData.playerID])
        }
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            MatchingView(rootIsActive: .constant(false))
                .environmentObject(GameData())
                .environmentObject(GameService())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
