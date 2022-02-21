//
//  EndGameView.swift
//  EndGameView
//
//  Created by 松本真太朗 on 2021/08/24.
//

import SwiftUI

struct EndGameView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var gameService: GameService
    @Binding var rootIsActive: Bool
    
    @available(iOS 15.0.0, *)
    func updateRate() async {
        if (gameData.winnerID != userData.userID) { return }
        do {
            let winnerID = userData.userID
            let loserID = gameData.opponentID
            try await UserService().updateRate(winnerID: winnerID, loserID: loserID)
        } catch(let error) {
            debugPrint(error)
        }
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                CustomText(content: "終局", size: 36, tracking: 0)
                    .position(x: width/2, y: height*0.1)
                HStack {
                    CustomText(content: "勝者", size: 24, tracking: 0)
                        .padding(.trailing, 20)
                    CustomText(content: gameData.winnerID == userData.userID ? userData.userName : gameData.opponentName, size: 24, tracking: 0)
                        .padding(.trailing, 20)
                    CustomText(content: String(gameData.winnerID == userData.userID ? gameData.myScore : gameData.yourScore), size: 24, tracking: 0)
                        .padding(.trailing, 20)
                }
                .position(x: width/2, y: height*0.4)
                HStack {
                    CustomText(content: "敗者", size: 24, tracking: 0)
                        .padding(.trailing, 20)
                    CustomText(content: gameData.winnerID != userData.userID ? userData.userName : gameData.opponentName, size: 24, tracking: 0)
                        .padding(.trailing, 20)
                    CustomText(content: String(gameData.winnerID != userData.userID ? gameData.myScore : gameData.yourScore), size: 24, tracking: 0)
                        .padding(.trailing, 20)
                }
                .position(x: width/2, y: height*0.5)
                if gameData.isDisconnected {
                    CustomText(content: "接続切れ", size: 24, tracking: 0)
                        .position(x: width*0.8, y: height*0.5)
                } else if gameData.isSurrender {
                    CustomText(content: "降参", size: 24, tracking: 0)
                        .position(x: width*0.8, y: height*0.5)
                }
                
                Button(action: {
                    Task {
                        await updateRate()
                        gameService.socket.removeAllHandlers()
                        gameData.allReset()
                        rootIsActive = false
                    }
                }) {
                    CustomText(content: "戻る", size: 20, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                }
                .position(x: width/2, y: height*0.8)
            }
        }
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            EndGameView(rootIsActive: .constant(false))
                .environmentObject(GameData())
                .environmentObject(UserData())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
