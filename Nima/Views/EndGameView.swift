//
//  EndGameView.swift
//  EndGameView
//
//  Created by 松本真太朗 on 2021/08/24.
//

import SwiftUI

struct EndGameView: View {
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var gameService: GameService
    @Binding var rootIsActive: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            CustomText(content: "終局", size: 36, tracking: 0)
                .position(x: width/2, y: height*0.1)
            HStack {
                CustomText(content: "勝者", size: 24, tracking: 0)
                    .padding(.trailing, 20)
                CustomText(content: gameData.winnerID == gameData.playerID ? gameData.playerID : gameData.opponentID, size: 24, tracking: 0)
                    .padding(.trailing, 20)
                CustomText(content: String(gameData.winnerID == gameData.playerID ? gameData.myScore : gameData.yourScore), size: 24, tracking: 0)
                    .padding(.trailing, 20)
            }
            .position(x: width/2, y: height*0.4)
            HStack {
                CustomText(content: "敗者", size: 24, tracking: 0)
                    .padding(.trailing, 20)
                CustomText(content: gameData.winnerID != gameData.playerID ? gameData.playerID : gameData.opponentID, size: 24, tracking: 0)
                    .padding(.trailing, 20)
                CustomText(content: String(gameData.winnerID != gameData.playerID ? gameData.myScore : gameData.yourScore), size: 24, tracking: 0)
                    .padding(.trailing, 20)
            }
            .position(x: width/2, y: height*0.5)
            if gameData.isDisconnected {
                CustomText(content: "接続切れ", size: 24, tracking: 0)
                    .position(x: width*0.8, y: height*0.5)
            }
            
            Button(action: {
                gameService.socket.disconnect()
                rootIsActive = false
            }) {
                CustomText(content: "戻る", size: 20, tracking: 0)
                    .foregroundColor(Colors.init().navy)
            }
            .position(x: width/2, y: height*0.8)
        }
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            EndGameView(rootIsActive: .constant(false))
                .environmentObject(GameData())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
