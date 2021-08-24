//
//  EndGameView.swift
//  EndGameView
//
//  Created by 松本真太朗 on 2021/08/24.
//

import SwiftUI

struct EndGameView: View {
    @EnvironmentObject var gameData: GameData
    var body: some View {
        VStack {
            Text("終局").font(.title)
                .padding(.bottom, 20)
            HStack {
                Text("勝者")
                    .padding(.trailing, 20)
                Text(gameData.winnerID == gameData.playerID ? gameData.playerID : gameData.opponentID)
                    .padding(.trailing, 20)
                Text(String(gameData.winnerID == gameData.playerID ? gameData.myScore : gameData.yourScore))
                    .padding(.trailing, 20)
            }
            HStack {
                Text("敗者")
                    .padding(.trailing, 20)
                Text(gameData.winnerID != gameData.playerID ? gameData.playerID : gameData.opponentID)
                    .padding(.trailing, 20)
                Text(String(gameData.winnerID != gameData.playerID ? gameData.myScore : gameData.yourScore))
                    .padding(.trailing, 20)
            }
        }
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView()
            .environmentObject(GameData())
    }
}
