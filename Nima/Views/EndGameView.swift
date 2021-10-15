//
//  EndGameView.swift
//  EndGameView
//
//  Created by 松本真太朗 on 2021/08/24.
//

import SwiftUI

struct EndGameView: View {
    @EnvironmentObject var gameData: GameData
    @Binding var rootIsActive: Bool
    
    var body: some View {
        VStack {
            CustomText(content: "終局", size: 36, tracking: 0)
                .padding(.top, 20)
            Spacer()
            HStack {
                CustomText(content: "勝者", size: 24, tracking: 0)
                    .padding(.trailing, 20)
                CustomText(content: gameData.winnerID == gameData.playerID ? gameData.playerID : gameData.opponentID, size: 24, tracking: 0)
                    .padding(.trailing, 20)
                CustomText(content: String(gameData.winnerID == gameData.playerID ? gameData.myScore : gameData.yourScore), size: 24, tracking: 0)
                    .padding(.trailing, 20)
            }
            HStack {
                CustomText(content: "敗者", size: 24, tracking: 0)
                    .padding(.trailing, 20)
                CustomText(content: gameData.winnerID != gameData.playerID ? gameData.playerID : gameData.opponentID, size: 24, tracking: 0)
                    .padding(.trailing, 20)
                CustomText(content: String(gameData.winnerID != gameData.playerID ? gameData.myScore : gameData.yourScore), size: 24, tracking: 0)
                    .padding(.trailing, 20)
            }
            Spacer()
            
            Button(action: { rootIsActive = false }) {
                CustomText(content: "戻る", size: 20, tracking: 0)
                    .foregroundColor(Colors.init().navy)
            }
            .padding(.bottom, 20)
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
