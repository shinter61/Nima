//
//  TilesView.swift
//  TilesView
//
//  Created by 松本真太朗 on 2021/10/30.
//

import SwiftUI

struct TilesView: View {
    @EnvironmentObject var gameData: GameData
    var winnerID: String
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            HStack(alignment: .center, spacing: -6, content: {
                ForEach(Array((winnerID == gameData.playerID ? gameData.myTiles : gameData.yourTiles).enumerated()), id: \.offset) { index, tile in
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 60, alignment: .center)
                }
            })
            .padding(.trailing, 6)
            
            HStack(alignment: .center, spacing: -2, content: {
                ForEach(winnerID == gameData.playerID ? gameData.myMinkos : gameData.yourMinkos, id: \.self) { tile in
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
            
            HStack(alignment: .center, spacing: -2, content: {
                ForEach(gameData.playerID == winnerID ? gameData.myAnkans : gameData.yourAnkans, id: \.self) { tile in
                    Image("back")
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
                        .frame(width: 40, height: 60, alignment: .center)
                        .padding(-2)
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 60, alignment: .center)
                        .padding(-2)
                        .padding(.trailing, 10)
                }
            })
            
            HStack(alignment: .center, spacing: -2, content: {
                ForEach(gameData.playerID == winnerID ? gameData.myMinkans : gameData.yourMinkans, id: \.self) { tile in
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
        })
    }
}

struct TilesView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            TilesView(winnerID: "")
                .environmentObject(GameData())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
