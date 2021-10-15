//
//  MinkoView.swift
//  MinkoView
//
//  Created by 松本真太朗 on 2021/08/19.
//

import SwiftUI

struct MinkoView: View {
    @EnvironmentObject var gameData: GameData
    var playerID: String
    var body: some View {
        if gameData.playerID == playerID {
            HStack(alignment: .center, spacing: -2, content: {
                ForEach(gameData.myMinkos, id: \.self) { tile in
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
                ForEach(gameData.yourMinkos, id: \.self) { tile in
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
                        .padding(.trailing, 8)
                }
            })
        }
    }
}


struct MinkoView_Previews: PreviewProvider {
    static var previews: some View {
        MinkoView(playerID: "")
            .environmentObject(GameData())
    }
}
