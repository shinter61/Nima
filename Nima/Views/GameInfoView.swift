//
//  GameInfoView.swift
//  GameInfoView
//
//  Created by 松本真太朗 on 2021/10/14.
//

import SwiftUI

struct GameInfoView: View {
    @EnvironmentObject var gameData: GameData
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Colors.init().navy)
                .frame(width: 80, height: 80, alignment: .center)
            if gameData.yourRiichiTurn != -1 {
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 50, height: 8, alignment: .center)
                    Circle()
                        .fill(Colors.init().red)
                        .frame(width: 7, height: 7, alignment: .center)
                }
                .padding(.bottom, 62)
            }
            if gameData.myRiichiTurn != -1 {
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 50, height: 8, alignment: .center)
                    Circle()
                        .fill(Colors.init().red)
                        .frame(width: 7, height: 7, alignment: .center)
                }
                .padding(.top, 62)
            }
            VStack(alignment: .center, spacing: 4, content: {
                Group {
                    CustomText(content: "\(gameData.roundWind == "east" ? "東" : "南")\(gameData.round)局", size: 18, tracking: 0)
                    CustomText(content: "残り \(gameData.stockCount)", size: 18, tracking: 0)
                }
                .foregroundColor(Color.white)
            })
        }
    }
}

struct GameInfoView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            GameInfoView()
                .environmentObject(GameData())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
