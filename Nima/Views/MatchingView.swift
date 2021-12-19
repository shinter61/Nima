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
    @Binding var isAdTiming: Bool
    @State private var matchingFinished: Bool = false
    func addHandler(socket: SocketIOClient!) -> Void {
        socket.on(clientEvent: .connect) { (data, ack) in
            socket.emit("StartMatching", userData.userID, userData.userName)
        }
        socket.on("InformPlayersNames") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                gameData.roomID = dict["roomID"]!
                if userData.userID == Int(dict["player1ID"]!) {
                    gameData.opponentID = Int(dict["player2ID"]!)!
                    gameData.opponentName = dict["player2Name"]!
                    gameService.socket.emit("StartGame", gameData.roomID) // StartGameは2台につき1台からのみ発行
                } else if userData.userID == Int(dict["player2ID"]!) {
                    gameData.opponentID = Int(dict["player1ID"]!)!
                    gameData.opponentName = dict["player1Name"]!
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
                Button(action: {
                    gameService.socket.disconnect()
                    gameService.socket.removeAllHandlers()
                    gameData.allReset()
                    isAdTiming = false
                    rootIsActive = false
                }) {
                    CustomText(content: "キャンセル", size: 20, tracking: 0)
                        .foregroundColor(Colors().lightGray)
                }
                .position(x: width*0.85, y: height*0.85)
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
            gameService.socket.connect(withPayload: ["name": userData.userName, "id": userData.userID])
        }
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            MatchingView(rootIsActive: .constant(false), isAdTiming: .constant(false))
                .environmentObject(GameData())
                .environmentObject(GameService())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
