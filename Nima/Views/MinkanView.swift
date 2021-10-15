//
//  MinkanView.swift
//  MinkanView
//
//  Created by 松本真太朗 on 2021/08/31.
//

import SwiftUI

struct MinkanView: View {
    @EnvironmentObject var gameData: GameData
    var playerID: String
    var body: some View {
        if gameData.playerID == playerID {
            HStack(alignment: .center, spacing: -2, content: {
                ForEach(gameData.playerID == playerID ? gameData.myMinkans : gameData.yourMinkans, id: \.self) { tile in
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 60, alignment: .center)
                        .padding(-2)
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 60, alignment: .center)
                        .padding(-2)
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55, alignment: .center)
                        .rotationEffect(Angle(degrees: -90.0))
                        .padding(-2)
                        .padding(.bottom, -4)
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 60, alignment: .center)
                        .padding(-2)
                        .padding(.trailing, 10)
                }
            })
        } else {
            HStack(alignment: .center, spacing: 4, content: {
                ForEach(gameData.playerID == playerID ? gameData.myMinkans : gameData.yourMinkans, id: \.self) { tile in
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 60, alignment: .center)
                        .padding(-8)
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 60, alignment: .center)
                        .padding(-2)
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 55, alignment: .center)
                        .rotationEffect(Angle(degrees: -90.0))
                        .padding(-2)
                        .padding(.bottom, -4)
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 60, alignment: .center)
                        .padding(-2)
                        .padding(.trailing, 10)
                }
            })
        }
    }
}

struct MinkanView_Previews: PreviewProvider {
    static var previews: some View {
        MinkanView(playerID: "")
            .environmentObject(GameData())
    }
}
